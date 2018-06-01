class Swaggen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/2.1.1.tar.gz"
  sha256 "c820211608a886877e0f48906b1ab59ad2e2768ae5d949b9d17eba828dd2edc0"
  head "https://github.com/yonaskolb/SwagGen.git"

  depends_on :xcode

  def install

    # libxml2 has to be included in ISYSTEM_PATH for building one of
    # dependencies. It didn't happen automatically before Xcode 9.3
    # so homebrew patched environment variable to get it work.
    #
    # That works fine when you have just Xcode installed, but there
    # is also CLT. If it is also installed, ISYSTEM_PATH has
    # a reference to CLT libxml2 AND a reference to Xcode default
    # toolchain libxml2. That causes build failure with "module redeclared"
    # error. So if both Xcode and CLT are installed one reference
    # has to be removed.
    #
    # It's a bug of homebrew but before it's fixed, it's easier
    # to provide in-place workaround for now.
    # Please remove this once homebrew is patched.

    # step 1: capture old value and patch environment
    if OS::Mac::Xcode.version >= Version.new("9.3") && !OS::Mac::Xcode.without_clt? then
      old_isystem_paths = ENV["HOMEBREW_ISYSTEM_PATHS"]
      ENV["HOMEBREW_ISYSTEM_PATHS"] = old_isystem_paths.gsub("/usr/include/libxml2", "")
    end

    # step 2: usual build
    system "make", "install", "PREFIX=#{prefix}"

    # step 3: restoring environment to pristine state
    ENV["HOMEBREW_ISYSTEM_PATHS"] = old_isystem_paths if defined? old_isystem_paths
    
  end
end
