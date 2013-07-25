
MainLoop main_loop;

async void run () {
	AsyncTest.Test test = yield Bus.get_proxy (BusType.SESSION, "org.example.Test", "/org/example/test");

	yield test.test_void ();

	int j, k;
	k = yield test.test_int (42, out j);
	assert (j == 23);
	assert (k == 11);

	string t, u;
	u = yield test.test_string ("hello", out t);
	assert (t == "world");
	assert (u == "vala");

	Foo foo;
	foo = yield test.test_foo ("hello");
	assert (foo.bar == "hello");

	Foo[] foos;
	foos = yield test.test_foos ("hello");
	assert (foos[0].bar == "hello");
	
	main_loop.quit ();
}

void main () {
	// client
	run.begin ();

	main_loop = new MainLoop (null, false);
	main_loop.run ();
}

