package vimgo

import "testing"

func TestSetGetMaxSize(t *testing.T) {
	prevMaxSize := MaxSize()
	if err := SetMaxsize(100); err != nil {
		t.Error(err)
	}

	if MaxSize() != 100 {
		t.Error("MaxSize() should return 100")
	}

	if err := SetMaxsize(0); err == nil {
		t.Error("SetMaxsize(0) should return an error")
	}

	SetMaxsize(prevMaxSize)
}
