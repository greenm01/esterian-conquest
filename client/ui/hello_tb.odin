package ui

import tb "termbox2"

hello_tb :: proc() {

	tb.init()
	defer tb.shutdown()
		
	ev: tb.Event
	y: i32 = 0

  tb.printf(0, y+1, tb.GREEN, 0, "hello from termbox")
  tb.printf(0, y+2, 0, 0, "width=%d height=%d", tb.width(), tb.height())
  tb.printf(0, y+3, 0, 0, "press any key...")
  tb.present()

  tb.poll_event(&ev)

  y = 4
  tb.printf(0, y, 0, 0, "event type=%d key=%d ch=%c", ev.type, ev.key, ev.ch)
  tb.printf(0, y+1, 0, 0, "press any key to quit...")
  tb.present()

  tb.poll_event(&ev)

}
