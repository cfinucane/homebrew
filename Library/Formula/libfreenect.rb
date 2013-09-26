require 'formula'

class Libfreenect < Formula
  homepage 'http://openkinect.org'
  url 'https://github.com/OpenKinect/libfreenect/archive/v0.2.0.tar.gz'
  sha1 'cc6ec1d48411439769d51a645f684a8aeedcf1f1'

  head 'https://github.com/OpenKinect/libfreenect.git'

  option :universal

  depends_on 'cmake' => :build
  depends_on 'libusb'
  depends_on :python

  def install
    if build.universal?
      ENV.universal_binary
      ENV['CMAKE_OSX_ARCHITECTURES'] = Hardware::CPU.universal_archs.as_cmake_arch_flags
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end

    ENV.append_to_cflags "-L#{Dir.getwd}/build/lib"

    cd "wrappers/python" do
      python do
        system python, "setup.py",
                       "install",
                       "--prefix=#{prefix}"
      end
    end
  end
end
