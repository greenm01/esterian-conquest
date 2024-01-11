// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

import "core:bytes"
import "core:io"
import "core:strings"
import "core:unicode/utf8"

/*
import (
	"fmt"
	"math"
	"reflect"

	rw "github.com/mattn/go-runewidth"
	wordwrap "github.com/mitchellh/go-wordwrap"
)

// InterfaceSlice takes an []interface{} represented as an interface{} and converts it
// https://stackoverflow.com/questions/12753805/type-converting-slices-of-interfaces-in-go
func InterfaceSlice(slice interface{}) []interface{} {
	s := reflect.ValueOf(slice)
	if s.Kind() != reflect.Slice {
		panic("InterfaceSlice() given a non-slice type")
	}

	ret := make([]interface{}, s.Len())

	for i := 0; i < s.Len(); i++ {
		ret[i] = s.Index(i).Interface()
	}

	return ret
}

// TrimString trims a string to a max length and adds '…' to the end if it was trimmed.
func TrimString(s string, w int) string {
	if w <= 0 {
		return ""
	}
	if rw.StringWidth(s) > w {
		return rw.Truncate(s, w, string(ELLIPSES))
	}
	return s
}

func SelectColor(colors []Color, index int) Color {
	return colors[index%len(colors)]
}

func SelectStyle(styles []Style, index int) Style {
	return styles[index%len(styles)]
}

// Math ------------------------------------------------------------------------

func SumIntSlice(slice []int) int {
	sum := 0
	for _, val := range slice {
		sum += val
	}
	return sum
}

func SumFloat64Slice(data []float64) float64 {
	sum := 0.0
	for _, v := range data {
		sum += v
	}
	return sum
}

func GetMaxIntFromSlice(slice []int) (int, error) {
	if len(slice) == 0 {
		return 0, fmt.Errorf("cannot get max value from empty slice")
	}
	var max int
	for _, val := range slice {
		if val > max {
			max = val
		}
	}
	return max, nil
}

func GetMaxFloat64FromSlice(slice []float64) (float64, error) {
	if len(slice) == 0 {
		return 0, fmt.Errorf("cannot get max value from empty slice")
	}
	var max float64
	for _, val := range slice {
		if val > max {
			max = val
		}
	}
	return max, nil
}

func GetMaxFloat64From2dSlice(slices [][]float64) (float64, error) {
	if len(slices) == 0 {
		return 0, fmt.Errorf("cannot get max value from empty slice")
	}
	var max float64
	for _, slice := range slices {
		for _, val := range slice {
			if val > max {
				max = val
			}
		}
	}
	return max, nil
}

func RoundFloat64(x float64) float64 {
	return math.Floor(x + 0.5)
}

func FloorFloat64(x float64) float64 {
	return math.Floor(x)
}

func AbsInt(x int) int {
	if x >= 0 {
		return x
	}
	return -x
}

func MinFloat64(x, y float64) float64 {
	if x < y {
		return x
	}
	return y
}

func MaxFloat64(x, y float64) float64 {
	if x > y {
		return x
	}
	return y
}

func MaxInt(x, y int) int {
	if x > y {
		return x
	}
	return y
}

func MinInt(x, y int) int {
	if x < y {
		return x
	}
	return y
}

*/

// []Cell ----------------------------------------------------------------------

// WrapCells takes []Cell and inserts Cells containing '\n' wherever a linebreak should go.
wrap_cells :: proc(cells: []Cell, width: uint) -> []Cell {
	str := cells_to_string(cells)
	wrapped := wrap_string(str, width)
	wrapped_cells := []Cell{}
	i := 0
	for _rune in wrapped {
		if _rune == '\n' {
			wrapped_cells = append(wrapped_cells, Cell{_rune, StyleClear})
		} else {
			wrapped_cells = append(wrapped_cells, Cell{_rune, cells[i].Style})
		}
		i += 1
	}
	return wrapped_cells
}

runes_to_styled_cells :: proc(runes: []rune, style: Style) -> []Cell {
	cells := make([]Cell,len(runes))
	for r, i in runes {
		cells[i] = Cell{r, style}
	}
	return cells
}

cells_to_string :: proc(cells: []Cell) -> string {
	runes := make([]rune, len(cells))
	defer delete(runes)
	for cell, i in cells {
		runes[i] = cell._rune
	}
	return utf8.runes_to_string(runes)
}

/*
func TrimCells(cells []Cell, w int) []Cell {
	s := cells_to_string(cells)
	s = TrimString(s, w)
	runes := []rune(s)
	newCells := []Cell{}
	for i, r := range runes {
		newCells = append(newCells, Cell{r, cells[i].Style})
	}
	return newCells
}

func SplitCells(cells []Cell, r rune) [][]Cell {
	splitCells := [][]Cell{}
	temp := []Cell{}
	for _, cell := range cells {
		if cell.Rune == r {
			splitCells = append(splitCells, temp)
			temp = []Cell{}
		} else {
			temp = append(temp, cell)
		}
	}
	if len(temp) > 0 {
		splitCells = append(splitCells, temp)
	}
	return splitCells
}

*/

Cell_With_X :: struct {
	x: int,
	cell: Cell,
}

build_cell_with_xarray :: proc(cells: []Cell) -> []Cell_With_X {
	cell_with_xarray := make([]Cell_With_X, len(cells))
	index := 0
	for cell, i in cells {
		cell_with_xarray[i] = Cell_With_X{index, cell}
		index += utf8.rune_size(cell._rune)
	}
	return cell_with_xarray
}

NBSP :: 0xA0

// ported from https://github.com/mitchellh/go-wordwrap
// WrapString wraps the given string within lim width in characters.
// Wrapping is currently naive and only happens at white-space. A future
// version of the library will implement smarter wrapping. This means that
// pathological cases can dramatically reach past the limit, such as a very
// long word.
wrap_string :: proc(s: string, lim: uint) -> string {
	// Initialize a buffer with a slightly larger size to account for breaks
	stream: io.Stream

	current: uint
	word_buf, space_buf: ^bytes.Buffer
	word_buf_len, space_buf_len: uint

	for char in s {
		if char == '\n' {
			if bytes.buffer_length(word_buf) == 0 {
				if current+space_buf_len > lim {
					current = 0
				} else {
					current += space_buf_len
					bytes.buffer_write_to(space_buf, stream)
				}
				bytes.buffer_reset(space_buf)
				space_buf_len = 0
			} else {
				current += space_buf_len + word_buf_len
				bytes.buffer_write_to(space_buf, stream)
				bytes.buffer_reset(space_buf)
				space_buf_len = 0
				bytes.buffer_write_to(word_buf, stream)
				bytes.buffer_reset(word_buf)
				word_buf_len = 0
			}
			io.write_rune(stream, char)
			current = 0
		} else if strings.is_space(char) && char != NBSP {
			if bytes.buffer_length(space_buf) == 0 || bytes.buffer_length(word_buf) > 0 {
				current += space_buf_len + word_buf_len
				bytes.buffer_write_to(space_buf, stream)
				bytes.buffer_reset(space_buf)
				space_buf_len = 0
				bytes.buffer_write_to(word_buf, stream)
				bytes.buffer_reset(word_buf)
				word_buf_len = 0
			}
			bytes.buffer_write_rune(space_buf, char)
			space_buf_len += 1
		} else {
			bytes.buffer_write_rune(word_buf, char)
			word_buf_len += 1

			if current+word_buf_len+space_buf_len > lim && word_buf_len < lim {
				io.write_rune(stream, '\n')
				current = 0
				bytes.buffer_reset(space_buf)
				space_buf_len = 0
			}
		}
	}

	if bytes.buffer_length(word_buf) == 0 {
		if current+space_buf_len <= lim {
			bytes.buffer_write_to(space_buf, stream)
		}
	} else {
		bytes.buffer_write_to(space_buf, stream)
		bytes.buffer_write_to(word_buf, stream)
	}

	buf := new(bytes.Buffer)
	bytes.buffer_read_from(buf, stream)
	return bytes.buffer_to_string(buf)
}
