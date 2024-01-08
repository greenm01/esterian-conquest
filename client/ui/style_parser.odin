// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

import 	"core:strings"

TOKEN_FG :: "fg"
TOKEN_BG :: "bg"
TOKEN_MODIFIER :: "mod"
TOKEN_ITEM_SEPERATOR :: ","
TOKEN_VALUE_SEPERATOR :: ":"
TOKEN_BEGIN_STYLED_TEXT :: '['
TOKEN_END_STYLED_TEXT :: ']'
TOKEN_BEGIN_STYLE :: '('
TOKEN_END_STYLE :: ')'

Parser_State :: distinct uint

PARSER_STATE_DEFAULT : Parser_State : 0
PARSER_STATE_STYLE_ITEMS : Parser_State : 1
PARSER_STATE_STYLE_TEXT : Parser_State : 2

// StyleParserColorMap can be modified to add custom color parsing to text
parser_color_map := map[string]Color{
	"red" =     RED,
	"blue" =    BLUE,
	"black" =   BLACK,
	"cyan" =    CYAN,
	"yellow" =  YELLOW,
	"white" =   WHITE,
	"clear" =   CLEAR,
	"green" =   GREEN,
	"magenta" = MAGENTA,
}

modifier_map := map[string]Modifier{
	"bold" =      BOLD,
	"underline" = UNDERLINE,
	"reverse" =   REVERSE,
}

// readStyle translates an []rune like `fg:red,mod:bold,bg:white` to a style
read_style :: proc(runes: []rune, default_style: Style) -> Style {
	style := default_style
	split := strings.split(string(runes), TOKEN_ITEM_SEPERATOR)
	for item, _ in split {
		pair := strings.split(item, TOKEN_VALUE_SEPERATOR)
		if len(pair) == 2 {
			switch pair[0] {
			case TOKEN_FG:
				style.fg = parser_color_map[pair[1]]
			case TOKEN_BG:
				style.bg = parser_color_map[pair[1]]
			case TOKEN_MODIFIER:
				style.modifier = modifier_map[pair[1]]
			}
		}
	}
	return style
}

// ParseStyles parses a string for embedded Styles and returns []Cell with the correct styling.
// Uses defaultStyle for any text without an embedded style.
// Syntax is of the form [text](fg:<color>,mod:<attribute>,bg:<color>).
// Ordering does not matter. All fields are optional.
func ParseStyles(s string, defaultStyle Style) []Cell {
	cells := []Cell{}
	runes := []rune(s)
	state := parserStateDefault
	styledText := []rune{}
	styleItems := []rune{}
	squareCount := 0

	reset := func() {
		styledText = []rune{}
		styleItems = []rune{}
		state = parserStateDefault
		squareCount = 0
	}

	rollback := func() {
		cells = append(cells, RunesToStyledCells(styledText, defaultStyle)...)
		cells = append(cells, RunesToStyledCells(styleItems, defaultStyle)...)
		reset()
	}

	// chop first and last runes
	chop := func(s []rune) []rune {
		return s[1 : len(s)-1]
	}

	for i, _rune := range runes {
		switch state {
		case parserStateDefault:
			if _rune == tokenBeginStyledText {
				state = parserStateStyledText
				squareCount = 1
				styledText = append(styledText, _rune)
			} else {
				cells = append(cells, Cell{_rune, defaultStyle})
			}
		case parserStateStyledText:
			switch {
			case squareCount == 0:
				switch _rune {
				case tokenBeginStyle:
					state = parserStateStyleItems
					styleItems = append(styleItems, _rune)
				default:
					rollback()
					switch _rune {
					case tokenBeginStyledText:
						state = parserStateStyledText
						squareCount = 1
						styleItems = append(styleItems, _rune)
					default:
						cells = append(cells, Cell{_rune, defaultStyle})
					}
				}
			case len(runes) == i+1:
				rollback()
				styledText = append(styledText, _rune)
			case _rune == tokenBeginStyledText:
				squareCount++
				styledText = append(styledText, _rune)
			case _rune == tokenEndStyledText:
				squareCount--
				styledText = append(styledText, _rune)
			default:
				styledText = append(styledText, _rune)
			}
		case parserStateStyleItems:
			styleItems = append(styleItems, _rune)
			if _rune == tokenEndStyle {
				style := readStyle(chop(styleItems), defaultStyle)
				cells = append(cells, RunesToStyledCells(chop(styledText), style)...)
				reset()
			} else if len(runes) == i+1 {
				rollback()
			}
		}
	}

	return cells
}
