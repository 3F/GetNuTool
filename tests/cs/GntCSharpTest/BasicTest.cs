using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace GntCSharpTest
{
    [Collection("Sequential")]
    public class BasicTest
    {
        private readonly _GetNuTool gnt = new();

        [Fact]
        public void GetAndUseTest1()
        {
            gnt.DeleteAllPackages();

            Assert.False(gnt.CheckPackage("Conari"));
            Assert.False(gnt.CheckPackage("Fnv1a128"));

            Assert.True(gnt.Run(ngpackages: "Conari;Fnv1a128"));

            Assert.True(gnt.CheckPackage("Conari"));
            Assert.True(gnt.CheckPackage("Fnv1a128"));

            Assert.Equal(3, gnt.stream.Count);
            Assert.Contains("GetNuTool ", gnt.stream[0]);
            Assert.Contains("github/3F", gnt.stream[0]);

            Assert.Contains("Conari ... ", gnt.stream[1]);
            Assert.Contains("Fnv1a128 ... ", gnt.stream[2]);

            //  -

            gnt.stream.Clear();
            gnt.DeletePackage("Fnv1a128");

            Assert.True(gnt.Run(ngpackages: "Conari;Fnv1a128"));

            Assert.True(gnt.CheckPackage("Conari"));
            Assert.True(gnt.CheckPackage("Fnv1a128"));

            Assert.Contains("Conari use ", gnt.stream[1]);
            Assert.Contains("Fnv1a128 ... ", gnt.stream[2]);
        }

        [Fact]
        public void EmptyRunTest1()
        {
            gnt.DeleteAllPackages();
            gnt.Run();

            Assert.Equal(2, gnt.stream.Count);
            Assert.Contains("GetNuTool ", gnt.stream[0]);
            Assert.Contains("github/3F", gnt.stream[0]);

            Assert.Contains("[STDERR] Empty .config + ngpackages", gnt.stream[1]);
        }

        [Fact]
        public void Sha1Test1()
        {
            gnt.DeleteAllPackages();
            gnt.Run(ngpackages: "Fnv1a128/1.0.0?cccccccccccccccccccccccccccccccccccccccc");
            Assert.False(gnt.CheckPackage("Fnv1a128"));

            Assert.Equal(3, gnt.stream.Count);

            Assert.Contains("Fnv1a128/1.0.0 ... ", gnt.stream[1]);
            string actualSha1 = Regex.Match(gnt.stream[2], @"\.\.\. (.+)\[x\]").Groups[1].Value;
            Assert.Contains($"cccccccccccccccccccccccccccccccccccccccc ... {actualSha1}[x]", gnt.stream[2]);

            gnt.stream.Clear();
            gnt.Run(ngpackages: $"Fnv1a128/1.0.0?{actualSha1}");
            Assert.True(gnt.CheckPackage("Fnv1a128", "1.0.0"));
            Assert.Equal(3, gnt.stream.Count);
            Assert.Contains($"{actualSha1} ... {actualSha1}", gnt.stream[2]);
        }

        [Fact]
        public void PackTest1()
        {
            gnt.DeleteNupkg("Fnv1a128", "1.0.0");
            gnt.Run(ngpackages: "Fnv1a128/1.0.0");
            Assert.False(gnt.CheckNupkg("Fnv1a128", "1.0.0"));
            gnt.stream.Clear();

            gnt.Run(tmode: "pack", ngin: gnt.GetPathToPackage("Fnv1a128", "1.0.0"));
            Assert.True(gnt.CheckNupkg("Fnv1a128", "1.0.0"));
            Assert.Equal(3, gnt.stream.Count);
            Assert.Contains(".nuspec use ", gnt.stream[1]);
            Assert.Contains("Creating package ", gnt.stream[2]);
            Assert.Contains("Fnv1a128.1.0.0.nupkg ...", gnt.stream[2]);
        }

        [Theory]
        [InlineData("get")]
        [InlineData("install")]
        [InlineData("touch")]
        public void InstallTest1(string tmode)
        {
            gnt.DeletePackage("GetNuTool", "1.9.0");
            gnt.UnsetFile("svc.gnt.bat");

            Assert.False(File.Exists("svc.gnt.bat"));
            gnt.Run(tmode, ngpackages: "GetNuTool/1.9.0");
            Assert.Equal(tmode != "touch", gnt.CheckPackage("GetNuTool", "1.9.0"));
            Assert.Equal(tmode != "get", File.Exists("svc.gnt.bat"));

            Assert.Equal(2, gnt.stream.Count);
            Assert.Contains("GetNuTool/1.9.0 ... ", gnt.stream[1]);
        }

        [Theory]
        [InlineData("get")]
        [InlineData("install")]
        public void InstallTest2(string tmode)
        {
            gnt.DeletePackage("GetNuTool", "1.9.0");
            gnt.UnsetFile("svc.gnt.bat");

            Assert.False(File.Exists("svc.gnt.bat"));
            gnt.Run(tmode, ngpackages: "GetNuTool/1.9.0");
            Assert.True(gnt.CheckPackage("GetNuTool", "1.9.0"));
            Assert.Equal(tmode != "get", File.Exists("svc.gnt.bat"));

            Assert.Equal(2, gnt.stream.Count);
            Assert.Contains("GetNuTool/1.9.0 ... ", gnt.stream[1]);

            //  -

            gnt.stream.Clear();
            gnt.UnsetFile("svc.gnt.bat");

            gnt.Run(tmode, ngpackages: "GetNuTool/1.9.0");
            Assert.True(gnt.CheckPackage("GetNuTool", "1.9.0"));
            Assert.False(File.Exists("svc.gnt.bat"));

            Assert.Equal(2, gnt.stream.Count);
            Assert.Contains("GetNuTool.1.9.0 use ", gnt.stream[1]);
        }

        class _GetNuTool: io.github._3F.GetNuTool
        {
            private readonly StringBuilder noline = new();
            private readonly string ngpath = "packages";

            public readonly List<string> stream = new(8);

            public bool CheckPackage(string name, string version = null, Action<string> ifExists = null)
                => Check(() => GetPathToPackage(name, version),
                                path =>
                                {
                                    if(File.Exists(Path.Combine(path, name + ".nuspec")))
                                        ifExists?.Invoke(path);
                                });

            public bool CheckNupkg(string name, string version, Action<string> ifExists = null)
                => Check(() => GetNupkg(name, version), ifExists);

            public void DeleteNupkg(string name, string version) => CheckNupkg(name, version, File.Delete);

            public string GetPathToPackage(string name, string version = null)
                => Path.Combine(ngpath, GetPackage(name, version));

            public void UnsetFile(string fname)
            {
                if(File.Exists(fname)) File.Delete(fname);
            }

            public void DeleteAllPackages()
            {
                if(Directory.Exists(ngpath)) Directory.Delete(ngpath, recursive: true);
            }

            public void DeletePackage(string name, string version = null)
                => CheckPackage(name, version, s => Directory.Delete(s, recursive: true));

            public override void StdOut(string msg = "", params object[] args)
                => noline.Append(string.Format(msg, args));

            public override void StdOutLine(string msg = "", params object[] args)
            {
                stream.Add(noline.ToString() + string.Format(msg, args));
                noline.Clear();
            }

            public override void StdErrLine(string msg = "", params object[] args)
                => StdOutLine("[STDERR] " + msg, args);

            private bool Check(Func<string> predicate, Action<string> ifExists = null)
            {
                string path = predicate();
                if(File.Exists(path) || Directory.Exists(path))
                {
                    ifExists?.Invoke(path);
                    return true;
                }
                return false;
            }

            private string GetPackage(string name, string version = null)
                => version == null ? name : $"{name}.{version}";

            private string GetNupkg(string name, string version) => $"{name}.{version}.nupkg";
        }
    }
}