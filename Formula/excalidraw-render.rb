class ExcalidrawRender < Formula
  include Language::Python::Virtualenv

  desc "Clean, browser-free renderer for .excalidraw files (PNG/SVG)"
  homepage "https://github.com/shivama205/excalidraw-render"
  url "https://files.pythonhosted.org/packages/1b/4e/ce815429448efe047dee3cdbfc28b2c3a86a81015ae5c5de43597f1dfd80/excalidraw_render-0.1.0.tar.gz"
  sha256 "809652143b54df308edc6ec8421d58d22c05ec559d89bb52efda3aacc6b1c407"
  license "MIT"

  depends_on "cairo"
  depends_on "python@3.13"

  resource "cairosvg" do
    url "https://files.pythonhosted.org/packages/38/07/e8412a13019b3f737972dea23a2c61ca42becafc16c9338f4ca7a0caa993/cairosvg-2.9.0.tar.gz"
    sha256 "1debb00cd2da11350d8b6f5ceb739f1b539196d71d5cf5eb7363dbd1bfbc8dc5"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/8c/21/c2bcdd5906101a30244eaffc1b6e6ce71a31bd0742a01eb89e660ebfac2d/pillow-12.2.0.tar.gz"
    sha256 "a830b1a40919539d07806aa58e1b114df53ddd43213d9c8b75847eee6c0182b5"
  end

  resource "cairocffi" do
    url "https://files.pythonhosted.org/packages/70/c5/1a4dc131459e68a173cbdab5fad6b524f53f9c1ef7861b7698e998b837cc/cairocffi-1.7.1.tar.gz"
    sha256 "2e48ee864884ec4a3a34bfa8c9ab9999f688286eb714a15a43ec9d068c36557b"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e0/20/92eaa6b0aec7189fa4b75c890640e076e9e793095721db69c5c81142c2e1/cssselect2-0.9.0.tar.gz"
    sha256 "759aa22c216326356f65e62e791d66160a0f9c91d1424e8d8adc5e74dddfc6fb"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/a3/ae/2ca4913e5c0f09781d75482874c3a95db9105462a92ddd303c7d285d3df2/tinycss2-1.5.1.tar.gz"
    sha256 "d339d2b616ba90ccce58da8495a78f46e55d4d25f9fd71dfd526f07e7d53f957"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # A minimal .excalidraw file with one rectangle should render to a PNG.
    fixture = testpath/"smoke.excalidraw"
    fixture.write <<~JSON
      {
        "type": "excalidraw",
        "version": 2,
        "source": "https://excalidraw.com",
        "elements": [
          {
            "id": "r1",
            "type": "rectangle",
            "x": 0, "y": 0, "width": 100, "height": 60,
            "strokeColor": "#1e1e1e",
            "backgroundColor": "#a5d8ff",
            "fillStyle": "solid",
            "strokeWidth": 2,
            "strokeStyle": "solid",
            "roughness": 0,
            "opacity": 100
          }
        ],
        "appState": {},
        "files": {}
      }
    JSON

    system bin/"excalidraw-render", fixture, "-o", testpath/"smoke.png", "--width", "200"
    assert_path_exists testpath/"smoke.png"
    # PNG magic header.
    assert_equal "\x89PNG\r\n\x1a\n".b, (testpath/"smoke.png").binread(8)
  end
end
