/*!
 * Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
 * Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
 * Licensed under the MIT License (MIT).
 * See accompanying LICENSE file or visit https://github.com/3F/GetNuTool
*/

// TODO: This was part of logic.targets separated between Tasks. New structure needs to be reviewed!

// NOTE: netfx 4.0+ platforms;
// NOTE: The default console logger can be disabled and currently exceptions are not caught at the top level; To make the code compact, use `return false` instead

if("$(logo)" != "no") Console.WriteLine("\nGetNuTool $(GetNuTool)\n(c) 2015-2025  Denis Kuzmin <x-3F@outlook.com> github/3F\n");

const string MSG_NOTFOUND = "{0} is not found ";

var ignore = new string[] // to ignore from package
{
    "/_rels/",
    "/package/",
    "/[Content_Types].xml"
};

Action<string, object> DebugMessage = (msg, args) =>
{
    if("$(debug)".Trim() == "true") Console.WriteLine(msg, args);
};

Func<string, XElement> _LoadXml = (input) =>
{
    try
    {
        return XDocument.Load(input).Root;
    }
    catch(Exception ex)
    {
        Console.Error.WriteLine(ex.Message);
        throw;
    }
};

const string WPATH = @"$(wpath)";
Environment.CurrentDirectory = WPATH; // important only for .pkg.install.* package scripts

if(tmode == "get" || tmode == "grab" || tmode == "install" || tmode == "run")
{
    string plist = @"$(ngpackages)";

    var sb = new StringBuilder();

    if(string.IsNullOrWhiteSpace(plist))
    {
        string ngconfig = @"$(ngconfig)";

        Action<string> LoadConf = (cfg) =>
        {
            foreach(XElement pkg in _LoadXml(cfg).Descendants("package"))
            {
                XAttribute id       = pkg.Attribute("id");
                XAttribute version  = pkg.Attribute("version");
                XAttribute output   = pkg.Attribute("output");
                XAttribute sha1     = pkg.Attribute("sha1");

                if(id == null)
                {
                    Console.Error.WriteLine("Invalid " + cfg);
                    return;
                }

                sb.Append(id.Value);

                if(version != null) sb.Append("/" + version.Value);
                if(sha1 != null) sb.Append("?" + sha1.Value);
                if(output != null) sb.Append(":" + output.Value);

                sb.Append(';');
            }
        };

        foreach(string cfg in ngconfig.Split(';'))
        {
            string lcfg = Path.Combine(WPATH, cfg);

            if(File.Exists(lcfg))
            {
                LoadConf(lcfg);
            }
            else DebugMessage(MSG_NOTFOUND, lcfg);
        }

        if(sb.Length < 1)
        {
            Console.Error.WriteLine("Empty .config + ngpackages");
            return false;
        }

        plist = sb.ToString();
    }

    /* -_-_-_--_-_-_--_-_-_- */

    string defpath  =@"$(ngpath)";
    string proxy    =@"$(proxycfg)";

    // https://github.com/3F/DllExport/issues/140
    // Since Tls13 (0x3000) is not available from obsolete assemblies,
    //    and SecurityProtocolType.SystemDefault (0) is defined only for netfx 4.7+, 4.8;
    //    We can try to bind this at runtime using the last available environment where this code was executed.

    // NOTE: ServicePointManager.SecurityProtocol = 0 may produce the following problem: An unexpected error occurred on a receive.

    foreach(var s in Enum.GetValues(typeof(SecurityProtocolType)).Cast<SecurityProtocolType>())
    {
        try
        {
            ServicePointManager.SecurityProtocol |= s;
        }
        catch(NotSupportedException)
        {
            // we don't care because property `ssl3` controls legacy protocols
        }
    }

    // drop support for ssl3 + tls1.0 + tls1.1
    // https://learn.microsoft.com/en-us/dotnet/api/system.net.securityprotocoltype
    if("$(ssl3)" != "true")
        ServicePointManager.SecurityProtocol &=
            ~(SecurityProtocolType)(/*Ssl3*/48 | /*Tls*/192 | /*Tls11*/768);

    Func<string, WebProxy> GetProxy = (cfg) =>
    {
        var auth = cfg.Split('@');
        if(auth.Length <= 1) return new WebProxy(auth[0], false);

        var login = auth[0].Split(':');
        return new WebProxy(auth[1], false)
        {
            Credentials = new NetworkCredential
            (
                login[0],
                login.Length > 1 ? login[1] : null
            )
        };
    };

    Func<string, string> SetDir = (path) =>
    {
        string dir = Path.GetDirectoryName(path);
        if(!Directory.Exists(dir)) Directory.CreateDirectory(dir);
        return path;
    };

    Func<string, string, string, string, bool> GetLink = (link, name, path, sha1) =>
    {
        string to = Path.GetFullPath
        (
            Path.Combine(WPATH, path ?? name ?? string.Empty)
        );

        if(Directory.Exists(to) || File.Exists(to))
        {
            Console.WriteLine("{0} use {1}", name, to);
            return true;
        }

        Console.Write(link + " ... ");

        bool grab = tmode == "grab";

        string tmp = grab
                    ? SetDir(to)
                    : Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());

        using(var l = new WebClient())
        {
            try
            {
                if(!string.IsNullOrEmpty(proxy))
                {
                    l.Proxy = GetProxy(proxy);
                }

                l.Headers.Add("User-Agent", "GetNuTool/$(GetNuTool)");
                l.UseDefaultCredentials = true;

                // `WebClient.Credentials` will not affect for used proxy: https://github.com/3F/DllExport/issues/133
                if(l.Proxy != null && l.Proxy.Credentials == null) // when no proxy key or when GetProxy() uses auth[0]
                {
                    l.Proxy.Credentials = CredentialCache.DefaultCredentials;
                }

                l.DownloadFile(@"$(ngserver)" + link, tmp);
            }
            catch(Exception ex)
            {
                Console.Error.WriteLine(ex.Message);
                return false;
            }
        }

        Console.WriteLine(to);

        if(sha1 != null)
        {
            Console.Write("{0} ... ", sha1);
            using(SHA1 algo = System.Security.Cryptography.SHA1.Create())
            {
                sb.Clear();

                using(var stream = new FileStream(tmp, FileMode.Open, FileAccess.Read))
                foreach(byte b in algo.ComputeHash(stream))
                    sb.Append(b.ToString("x2"));

                Console.Write(sb.ToString());
                if(!sb.ToString().Equals(sha1, StringComparison.OrdinalIgnoreCase))
                {
                    Console.WriteLine("[x]");
                    return false;
                }
                Console.WriteLine();
            }
        }

        if(grab) return true;

        using(Package pkg = ZipPackage.Open(tmp, FileMode.Open, FileAccess.Read))
        {
            foreach(PackagePartCollection part in pkg.GetParts())
            {
                string uri = Uri.UnescapeDataString(part.Uri.OriginalString);
                if(ignore.Any(x => uri.StartsWith(x, StringComparison.Ordinal))) continue;

                string dest = Path.Combine(to, uri.TrimStart('/'));
                DebugMessage("- {0}", uri);

                using(Stream src = part.GetStream(FileMode.Open, FileAccess.Read))
                using(FileStream target = File.OpenWrite(SetDir(dest)))
                {
                    try
                    {
                        src.CopyTo(target);
                    }
                    catch(FileFormatException) { DebugMessage("[x]?crc: {0}", dest); }
                }
            }
        }

        if(tmode == "install" || tmode == "run")
        {
            string pkgi = to + "/.pkg.install." + (Path.VolumeSeparatorChar == ':' ? "bat" : "sh");
            if(File.Exists(pkgi))
            {
                DebugMessage(tmode + " {0}", pkgi);
                System.Diagnostics
                    // Versions of the arguments format:
                    // v1: 1 tmode "path to the working directory" "path to the package"
                    .Process.Start(pkgi, "1 "+ tmode +" \""+ WPATH +"\" \""+ to +"\"")
                    .Dispose();
            }
        }

        File.Delete(tmp);
        return true;
    };

    //Format: id[/version][?sha1][:path];id2[/version][?sha1][:path];...

    foreach(string pkg in plist.Split(';'))
    {
        if(pkg == string.Empty) continue;

        string[] ident  = pkg.Split(new[] { ':' }, 2);
        string[] link   = ident[0].Split(new[] { '?' }, 2);
        string path     = ident.Length > 1 ? ident[1] : null;
        string name     = link[0].Replace('/', '.').Trim();

        if(!string.IsNullOrEmpty(defpath))
        {
            path = Path.Combine(defpath, path ?? name);
        }

        if(!GetLink(link[0], name, path, /*sha1:*/ link.Length > 1 ? link[1] : null)
            && "$(break)".Trim() != "no") return false;
    }
}
else if(tmode == "pack")
{
    const string EXT_NUSPEC = ".nuspec";
    const string TAG_META   = "metadata";

    // Tags
    const string ID     = "id";
    const string VER    = "version";

    string dir = Path.Combine(WPATH, @"$(ngin)");
    if(!Directory.Exists(dir))
    {
        Console.Error.WriteLine(MSG_NOTFOUND, dir);
        return false;
    }

    // Get metadata

    string nuspec = Directory.GetFiles(dir, "*" + EXT_NUSPEC).FirstOrDefault();
    if(nuspec == null)
    {
        Console.Error.WriteLine(MSG_NOTFOUND + dir, EXT_NUSPEC);
        return false;
    }
    Console.WriteLine("{0} use {1}", EXT_NUSPEC, nuspec);

    XElement root = _LoadXml(nuspec).Elements().FirstOrDefault(x => x.Name.LocalName == TAG_META);
    if(root == null)
    {
        Console.Error.WriteLine(MSG_NOTFOUND, TAG_META);
        return false;
    }

    var metadata = new System.Collections.Generic.Dictionary<string, string>();

    Func<string, string> _GetMeta = (key)
        => metadata.ContainsKey(key) ? metadata[key] : string.Empty;

    foreach(XElement tag in root.Elements())
        metadata[tag.Name.LocalName.ToLower()] = tag.Value;

    // Validate id; nuget core based rule

    if(!System.Text.RegularExpressions.Regex.IsMatch
        (
            _GetMeta(ID),
            @"^\w+(?:[_.-]\w+)*$"
        ))
    {
        Console.Error.WriteLine("Invalid id");
        return false;
    }

    // Format package

    string pout = string.Format("{0}.{1}.nupkg", _GetMeta(ID), _GetMeta(VER));

    string dout = Path.Combine(WPATH, @"$(ngout)");
    if(!string.IsNullOrWhiteSpace(dout))
    {
        if(!Directory.Exists(dout))
        {
            Directory.CreateDirectory(dout);
        }
        pout = Path.Combine(dout, pout);
    }

    Console.WriteLine("Creating package {0} ...", pout);
    using(string pkg = Package.Open(pout, FileMode.Create))
    {
        // manifest relationship

        Uri manifestUri = new Uri(string.Format("/{0}{1}", _GetMeta(ID), EXT_NUSPEC), UriKind.Relative);
        pkg.CreateRelationship(manifestUri, TargetMode.Internal, "http://schemas.microsoft.com/packaging/2010/07/manifest");

        // content

        foreach(string file in Directory.GetFiles(dir, "*.*", SearchOption.AllDirectories))
        {
            if(ignore.Any(x => file.StartsWith
            (
                Path.Combine(dir, x.Trim('/')), StringComparison.Ordinal
            ))) continue;

            string pUri = file.StartsWith(dir, StringComparison.OrdinalIgnoreCase)
                        ? file.Substring(dir.Length).TrimStart(Path.DirectorySeparatorChar)
                        : file;

            DebugMessage("+ {0}", pUri);

            PackagePart part = pkg.CreatePart
            (
                // to protect path without separators
                PackUriHelper.CreatePartUri
                (
                    new Uri
                    (
                        string.Join("/", pUri.Split('\\', '/').Select(Uri.EscapeDataString)),
                        UriKind.Relative
                    )
                ),
                "application/octet", //DEF_CONTENT_TYPE: System.Net.Mime.MediaTypeNames.Application.Octet
                CompressionOption.Maximum
            );

            using (Stream tstream = part.GetStream())
            using(var fs = new FileStream(file, FileMode.Open, FileAccess.Read)) {
                fs.CopyTo(tstream);
            }
        }

        // metadata

        PackageProperties _p = pkg.PackageProperties;

        _p.Creator          = _GetMeta("authors");
        _p.Description      = _GetMeta("description");
        _p.Identifier       = _GetMeta(ID);
        _p.Version          = _GetMeta(VER);
        _p.Keywords         = _GetMeta("tags");
        _p.Title            = _GetMeta("title");
        _p.LastModifiedBy   = "GetNuTool/$(GetNuTool)";
    }
}

else return false;