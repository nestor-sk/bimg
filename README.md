# vimgo ![Build and test](https://github.com/nestor-sk/vimgo/actions/workflows/build_test.yaml/badge.svg) [![Coverage Status](https://coveralls.io/repos/github/nestor-sk/vimgo/badge.svg?branch=main)](https://coveralls.io/github/nestor-sk/vimgo?branch=main) ![License](https://img.shields.io/badge/license-MIT-blue.svg)

---

IMPORTANT: This is a fork of https://github.com/h2non/bimg/tree/44c1dfbd7e8088698bb032e690dacca1b90fe891 @ March 15, 2020. It is expected to diverge so much that it will become its own separeted "package". The goal of this fork is to break support for anything lower than libvips v8.14 and go v1.20 and cover as many of the open issues in the original repo.

---

Small [Go](http://golang.org) package for fast high-level image processing using [libvips](https://github.com/libvips/libvips) via C bindings, providing a simple [programmatic API](#examples).

vimgo was designed to be a small and efficient library supporting common [image operations](#supported-image-operations) such as crop, resize, rotate, zoom or watermark. It can read JPEG, PNG, WEBP natively, and optionally TIFF, PDF, GIF, SVG and AVIF formats if `libvips` is compiled with proper library bindings. vimgo is able to output images as JPEG, PNG and WEBP formats, including transparent conversion across them.

vimgo uses internally libvips, a powerful library written in C for image processing which requires a [low memory footprint](https://github.com/libvips/libvips/wiki/Speed_and_Memory_Use)
and it's typically 4x faster than using the quickest ImageMagick and GraphicsMagick settings or Go native `image` package, and in some cases it's even 8x faster processing JPEG images.

vimgo is a forked from [bimg](https://github.com/h2non/bimg) which was heavily inspired in [sharp](https://github.com/lovell/sharp), its homologous package built for [node.js](http://nodejs.org).

## Contents

- [Supported image operations](#supported-image-operations)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Performance](#performance)
- [Benchmark](#benchmark)
- [Examples](#examples)
- [Debugging](#debugging)
- [API](#api)
- [Credits](#credits)

## Supported image operations

- Resize
- Enlarge
- Crop (including smart crop support)
- Rotate (with auto-rotate based on EXIF orientation)
- Flip (with auto-flip based on EXIF metadata)
- Flop
- Zoom
- Thumbnail
- Extract area
- Watermark (using text or image)
- Gaussian blur effect
- Custom output color space (RGB, grayscale...)
- Format conversion (with additional quality/compression settings)
- EXIF metadata (size, alpha channel, profile, orientation...)
- Trim

## Prerequisites

- [libvips](https://github.com/libvips/libvips) 8.14+
- C compatible compiler such as gcc 4.6+ or clang 3.0+
- Go 1.20+.

## Installation

```bash
go get -u github.com/nestor-sk/vimgo
```

### libvips

Follow `libvips` [installation instructions](https://libvips.github.io/libvips/install.html)

## Performance

libvips is probably the fastest open source solution for image processing.
Here you can see some performance test comparisons for multiple scenarios:

- [libvips speed and memory usage](https://github.com/libvips/libvips/wiki/Speed-and-memory-use)

## Benchmark

Tested using Go 1.5.1 and libvips-7.42.3 in OSX i7 2.7Ghz

```
BenchmarkRotateJpeg-8     	      20	  64686945 ns/op
BenchmarkResizeLargeJpeg-8	      20	  63390416 ns/op
BenchmarkResizePng-8      	     100	  18147294 ns/op
BenchmarkResizeWebP-8     	     100	  20836741 ns/op
BenchmarkConvertToJpeg-8  	     100	  12831812 ns/op
BenchmarkConvertToPng-8   	      10	 128901422 ns/op
BenchmarkConvertToWebp-8  	      10	 204027990 ns/op
BenchmarkCropJpeg-8       	      30	  59068572 ns/op
BenchmarkCropPng-8        	      10	 117303259 ns/op
BenchmarkCropWebP-8       	      10	 107060659 ns/op
BenchmarkExtractJpeg-8    	      50	  30708919 ns/op
BenchmarkExtractPng-8     	    3000	    595546 ns/op
BenchmarkExtractWebp-8    	    3000	    386379 ns/op
BenchmarkZoomJpeg-8       	      10	 160005424 ns/op
BenchmarkZoomPng-8        	      30	  44561047 ns/op
BenchmarkZoomWebp-8       	      10	 126732678 ns/op
BenchmarkWatermarkJpeg-8  	      20	  79006133 ns/op
BenchmarkWatermarPng-8    	     200	   8197291 ns/op
BenchmarkWatermarWebp-8   	      30	  49360369 ns/op
```

## Examples

You can find some examples in the [examples](./examples/main.go) directory. Try them out just running `make examples` in the root directory!

Using `vimgo` is simple as:

```go
package main

import (
	"os"
	"github.com/nestor-sk/vimgo"
)

func main() {
	buffer, _ := os.ReadFile("image.jpg")
	newImage, _ := vimgo.NewImage(buffer).Resize(800, 600)
	os.WriteFile("new.jpg", newImage, 0644)
}
```

## Debugging

Run the process passing the `DEBUG` environment variable

```
DEBUG=vimgo ./app
```

Enable libvips traces (note that a lot of data will be written in stdout):

```
VIPS_TRACE=1 ./app
```

You can also dump a core on failure:

```c
g_log_set_always_fatal(
                G_LOG_FLAG_RECURSION |
                G_LOG_FLAG_FATAL |
                G_LOG_LEVEL_ERROR |
                G_LOG_LEVEL_CRITICAL |
                G_LOG_LEVEL_WARNING );
```

Or set the G_DEBUG environment variable:

```
export G_DEBUG=fatal-warnings,fatal-criticals
```

## API

See [godoc reference](https://godoc.org/github.com/h2non/bimg) for detailed API documentation.

## Credits

People who recurrently contributed to improve `vimgo` in some way.

- [Nestor Lafon-Gracia](https://github.com/nestorlafon)

People who recurrently contributed to improve `bimg` in some way.

- [Tomás Aparicio](https://github.com/h2non) - Original author and architect.
- [John Cupitt](https://github.com/jcupitt)
- [Yoan Blanc](https://github.com/greut)
- [Christophe Eblé](https://github.com/chreble)
- [Brant Fitzsimmons](https://github.com/bfitzsimmons)
- [Thomas Meson](https://github.com/zllak)

Thank you!

## License

MIT - Tomas Aparicio

---

TODO

- [ ] generate documentation and add badge (and update documentation secition)
- [ ] make sure coverall coverage works
- [ ] benchmarking (md section)
