from conans import ConanFile, CMake


class HelloConan(ConanFile):
    name = "conan_manifest"
    version = "5.6.4"
    settings = "os", "compiler", "arch"
    options = {"shared": [True, False]}
    default_options = "shared=False"
    generators = "cmake"
    exports_sources = "src/*"

    def build(self):
        for bt in ("Debug", "Release"):
            cmake = CMake(self, build_type=bt)
            cmake.configure(source_folder="src")
            cmake.build()
            cmake.install()

    def requirements(self):
        self.requires("poco/[>1.14.1,<1.14.3]")
        self.requires('zlib/1.2.11')
        self.requires('openssl/3.6.0')

    def build_requirements(self):
        self.tool_requires('7zip/19.00')
        self.tool_requires("cmake/3.22.6")
