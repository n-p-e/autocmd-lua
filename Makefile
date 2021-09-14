test:
	nvim --headless --noplugin -u tests/test_init.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/test_init.vim'}"
