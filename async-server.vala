
[DBus (name = "org.example.Test")]
class TestImpl : Object, AsyncTest.Test {
	public async void test_void () {
		Idle.add (test_void.callback);
		yield;
	}

	public async int test_int (int i, out int j) {
		assert (i == 42);
		Idle.add (test_int.callback);
		yield;
		j = 23;
		return 11;
	}

	public async string test_string (string s, out string t) {
		assert (s == "hello");
		Idle.add (test_string.callback);
		yield;
		t = "world";
		return "vala";
	}
	
	public async Foo test_foo (string s) {
		assert (s == "hello");
		Idle.add (test_foo.callback);
		yield;
		Foo foo = Foo();
		foo.bar = s;
		return foo;
	}

	public async Foo[] test_foos (string s) {
		assert (s == "hello");
		Idle.add (test_foos.callback);
		yield;
		var foos = new Foo[0];
		Foo foo = Foo();
		foo.bar = s;
		foos += foo;
		return foos;
	}

}

MainLoop main_loop;

void client_exit (Pid pid, int status) {
	// client finished, terminate server
	assert (status == 0);
	main_loop.quit ();
}

void main () {
	var conn = Bus.get_sync (BusType.SESSION);
	conn.register_object ("/org/example/test", new TestImpl ());

	// try to register service in session bus
	var request_result = conn.call_sync ("org.freedesktop.DBus", "/org/freedesktop/DBus", "org.freedesktop.DBus", "RequestName",
	                                      new Variant ("(su)", "org.example.Test", 0x4), null, 0, -1);
	assert ((uint) request_result.get_child_value (0) == 1);

	// server ready, spawn client
	Pid client_pid;
	Process.spawn_async (null, { "async-client", "/dbus/async/client" }, null, SpawnFlags.DO_NOT_REAP_CHILD, null, out client_pid);
	ChildWatch.add (client_pid, client_exit);

	main_loop = new MainLoop ();
	main_loop.run ();
}
