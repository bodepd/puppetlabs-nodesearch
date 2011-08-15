#
# Class to verify that we can collect all of
# the nodes that have an assigned role
#
class test::pass_role(
  $nodes,
  $role
) {
  notify { $nodes:
    message => $role
  }
}
