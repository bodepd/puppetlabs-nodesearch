node one {
  include test::one
  include test
}

node two {
  include test::two
  include test
  class { 'test::pass_role':
    nodes => search_nodes({classes => ['test::one', 'test']}),
    role => 'test::one and test nodes',
  }
}

node three {
  include test::three
  include test
  class { 'test::pass_role':
    nodes => search_nodes({'facts.architecture' => 'i386'}),
    role => 'i386 nodes',
  }

}

node four {
  include test::four
  class { 'test::pass_role':
    nodes => search_nodes({'facts.architecture' => 'i386', 'classes' => ['test']}),
    role => 'i386 test nodes',
  }
}
