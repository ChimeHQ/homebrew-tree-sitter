class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/0.17.1.tar.gz"
  sha256 "07b62f5d4408a488589d918676184340ce6b7ee3a0d78ca5b8fb9d31be18eba0"
  head "https://github.com/tree-sitter/tree-sitter.git"

  def install
    ENV.append_to_cflags "-mmacosx-version-min=10.10"
    ENV.append "LDFLAGS", "-mmacosx-version-min=10.10"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <tree_sitter/api.h>
      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }
        // Because we have no language libraries installed, we cannot
        // actually parse a string succesfully. But, we can verify
        // that it can at least be attempted.
        const char *source_code = "empty";
        TSTree *tree = ts_parser_parse_string(
          parser,
          NULL,
          source_code,
          strlen(source_code)
        );
        if (tree == NULL) {
          printf("tree creation failed");
        }
        ts_tree_delete(tree);
        ts_parser_delete(parser);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltree-sitter", "-o", "test"
    assert_equal "tree creation failed", shell_output("./test")
  end
end