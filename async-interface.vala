namespace AsyncTest {
	[DBus (name = "org.example.Test")]
	interface TestInterface : Object {
		public abstract async string test_string (string s, out string t) throws IOError;
	}
}
