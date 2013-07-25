public struct Foo {
	string bar;
}

namespace AsyncTest {
	[DBus (name = "org.example.Test")]
	interface Test : Object {
		public abstract async void test_void () throws IOError;
		public abstract async int test_int (int i, out int j) throws IOError;
		public abstract async string test_string (string s, out string t) throws IOError;
		public abstract async Foo test_foo (string s) throws IOError;
		public abstract async Foo[] test_foos (string s) throws IOError;
	}
}
