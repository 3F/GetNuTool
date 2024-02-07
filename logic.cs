/*!
 * Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
 * Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
 * Licensed under the MIT License (MIT).
 * See accompanying LICENSE file or visit https://github.com/3F/GetNuTool
*/

// TODO: This was part of logic.targets separated between Tasks. New structure needs to be reviewed!

// NOTE: netfx 4.0+ platforms;
// NOTE: The default console logger can be disabled and currently exceptions are not caught at the top level; To make the code compact, use `return false` instead

if("$(logo)".Trim() != "no") Console.WriteLine("\nGetNuTool $(GetNuTool)\n(c) 2015-2024  Denis Kuzmin <x-3F@outlook.com> github/3F\n");

Action<string, object> DebugMessage = (s, p) =>
{
    if("$(debug)".Trim() == "true") Console.WriteLine(s, p);
};

if(tmode == "get" || tmode == "grab")
{
    string config   =@"$(ngconfig)";
    string plist    =@"$(ngpackages)";

    if(string.IsNullOrEmpty(plist))
    {
        Action<string, Queue<string>> LoadConf = (cfg, list) =>
        {
            foreach(XElement pkg in XDocument.Load(cfg).Descendants("package"))
            {
                XAttribute id       = pkg.Attribute("id");
                XAttribute version  = pkg.Attribute("version");
                XAttribute output   = pkg.Attribute("output");

                if(id == null)
                {
                    Console.Error.WriteLine("{0} is corrupted", cfg);
                    return;
                }

                string link = id.Value;

                if(version != null) link += "/" + version.Value;

                if(output != null)
                {
                    list.Enqueue(link + ":" + output.Value);
                    continue;
                }

                list.Enqueue(link);
            }
        };

        var ret = new Queue<string>();
        foreach(string cfg in config.Split
        (
            new char[] { config.IndexOf('|') != -1 ? '|' : ';' },
            StringSplitOptions.RemoveEmptyEntries
        ))
        {
            string lcfg = Path.Combine(@"$(wpath)", cfg);
            if(File.Exists(lcfg))
            {
                LoadConf(lcfg, ret);
            }
            else
            {
                Console.Error.WriteLine(".config {0} is not found", lcfg);
            }
        }

        if(ret.Count < 1)
        {
            Console.Error.WriteLine("Empty .config + ngpackages\n");
            return false;
        }

        plist = string.Join("|", ret.ToArray());
    }

    /* -_-_-_--_-_-_--_-_-_- */

    string defpath  =@"$(ngpath)";
    string proxy    =@"$(proxycfg)".Trim();

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
    if("$(ssl3)" != "true") ServicePointManager.SecurityProtocol &= ~(SecurityProtocolType)(48 | 192 | 768);

    // to ignore from package
    var ignore = new string[] { "/_rels/", "/package/", "/[Content_Types].xml" };

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

    Func<string, string, string, bool> GetLink = (link, name, path) =>
    {
        string to = Path.GetFullPath
        (
            Path.Combine(@"$(wpath)", path ?? name ?? string.Empty)
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
                if(l.Proxy.Credentials == null) // when no proxy key or when GetProxy() uses auth[0]
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
        File.Delete(tmp);
        return true;
    };

    //Format: id/version[:path];id2/version[:D:/path];...

    foreach(string pkg in plist.Split
    (
        new char[] { plist.IndexOf('|') != -1 ? '|' : ';' },
        StringSplitOptions.RemoveEmptyEntries
    ))
    {
        var ident   = pkg.Split(new char[] { ':' }, 2);
        var link    = ident[0];
        var path    = ident.Length > 1 ? ident[1] : null;
        var name    = link.Replace('/', '.');

        if(!string.IsNullOrEmpty(defpath))
        {
            path = Path.Combine(defpath, path ?? name);
        }

        if(!GetLink(link, name, path) && "$(break)".Trim() != "no") return false;
    }
}
else if(tmode == "pack")
{
    const string EXT_NUSPEC = ".nuspec";
    const string EXT_NUPKG  = ".nupkg";
    const string TAG_META   = "metadata";

    // Tags
    const string ID     = "id";
    const string VER    = "version";

    string dir = Path.Combine(@"$(wpath)", @"$(ngin)");
    if(!Directory.Exists(dir))
    {
        Console.Error.WriteLine("{0} is not found", dir);
        return false;
    }

    // Get metadata

    string nuspec = Directory.GetFiles(dir, "*" + EXT_NUSPEC).FirstOrDefault();
    if(nuspec == null)
    {
        Console.Error.WriteLine("{0} is not found {1}", EXT_NUSPEC, dir);
        return false;
    }
    Console.WriteLine("{0} use {1}", EXT_NUSPEC, nuspec);

    XElement root = XDocument.Load(nuspec).Root.Elements().FirstOrDefault(x => x.Name.LocalName == TAG_META);
    if(root == null)
    {
        Console.Error.WriteLine("{0} does not contain {1}", nuspec, TAG_META);
        return false;
    }

    var metadata = new Dictionary<string, string>();

    Func<string, string> _GetMeta = (key)
        => metadata.ContainsKey(key) ? metadata[key] : string.Empty;

    foreach(XElement tag in root.Elements())
        metadata[tag.Name.LocalName.ToLower()] = tag.Value;

    // Validate id; nuget core based rule

    if(_GetMeta(ID).Length > 100
        || !Regex.IsMatch
            (
                _GetMeta(ID),
                @"^\w+(?:[_.-]\w+)*$"
            ))
    {
        Console.Error.WriteLine("Invalid id");
        return false;
    }

    // Format package

    var ignore = new string[] // to ignore from package
    {
        Path.Combine(dir, "_rels"),
        Path.Combine(dir, "package"),
        Path.Combine(dir, "[Content_Types].xml")
    };

    string pout = string.Format("{0}.{1}{2}", _GetMeta(ID), _GetMeta(VER), EXT_NUPKG);

    string dout = Path.Combine(@"$(wpath)", @"$(ngout)");
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
            if(ignore.Any(x => file.StartsWith(x, StringComparison.Ordinal))) continue;

            string pUri;
            if(file.StartsWith(dir, StringComparison.OrdinalIgnoreCase))
            {
                pUri = file.Substring(dir.Length).TrimStart(Path.DirectorySeparatorChar);
            }
            else
            {
                pUri = file;
            }
            DebugMessage("+ {0}", pUri);

            PackagePart part = pkg.CreatePart
            (
                // to protect path without separators
                PackUriHelper.CreatePartUri
                (
                    new Uri
                    (
                        string.Join("/", pUri.Split('\\', '/').Select(p => Uri.EscapeDataString(p))),
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