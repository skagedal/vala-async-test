
[DBus (name = "org.example.Test")]
class TestImpl : Object, AsyncTest.TestInterface {

	public async string test_string (string s, out string t) {
		assert (s == "hello");
		Idle.add (test_string.callback);
		yield;
		t = "world";
		return "vala";
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
