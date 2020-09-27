class TreeSitterGo < Formula
  desc "Go grammar for tree-sitter"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter-go/archive/v0.16.1.tar.gz"
  sha256 "7278f1fd4dc4de8a13b0f60407425d38c5cb3973e1938d3031a68e1e69bd0b75"
  head "https://github.com/tree-sitter/tree-sitter-go.git"

  depends_on "node@10" => :build
  depends_on "tree-sitter"

  def install
    system "npm install"
    system "ar rcs libtree-sitter-go.a build/Release/obj.target/tree_sitter_go_binding/src/*"
    
    lib.install "libtree-sitter-go.a"

    go_h_contents = <<~EOS
    #ifndef TREE_SITTER_GO_H_
    #define TREE_SITTER_GO_H_

    #include <tree_sitter/parser.h>

    #ifdef __cplusplus
    extern "C" {
    #endif

    extern TSLanguage *tree_sitter_go();

    #ifdef __cplusplus
    }
    #endif

    #endif  // TREE_SITTER_GO_H_
    EOS
    
    (include/"tree_sitter_go.h").write go_h_contents
    
    pc_contents = <<~EOS
    libdir=#{lib}
    includedir=#{include}

    Name: tree-sitter-go
    Description: #{self.class.desc}
    Version: 0.16.1
    Libs: -L${libdir} -ltree-sitter-go
    Clfags: -I${includedir}
    EOS

    (lib/"pkgconfig/libtree-sitter-go.pc").write pc_contents
  end

  test do
    system "false"
  end
end
