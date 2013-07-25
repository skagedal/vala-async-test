
MainLoop main_loop;

async void run () {
	AsyncTest.TestInterface test = yield Bus.get_proxy (BusType.SESSION, "org.example.Test", "/org/example/test");

	string t, u;
	u = yield test.test_string ("hello", out t);
	assert (t == "world");
	assert (u == "vala");

	main_loop.quit ();
}

void main () {
	// client
	run.begin ();

	main_loop = new MainLoop (null, false);
	main_loop.run ();
}

