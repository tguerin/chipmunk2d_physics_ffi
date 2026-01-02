// Main test file that imports all test suites
// Individual test files are organized by component for better maintainability

import 'arbiter_test.dart' as arbiter_test;
import 'body_test.dart' as body_test;
import 'bounding_box_test.dart' as bounding_box_test;
import 'constraint_test.dart' as constraint_test;
import 'integration_test.dart' as integration_test;
import 'moment_test.dart' as moment_test;
import 'shape_test.dart' as shape_test;
import 'space_test.dart' as space_test;
import 'vector_test.dart' as vector_test;

void main() {
  vector_test.main();
  body_test.main();
  shape_test.main();
  space_test.main();
  constraint_test.main();
  arbiter_test.main();
  bounding_box_test.main();
  moment_test.main();
  integration_test.main();
}
