class GraphSystem::GraphBoxTest < Liza::BoxTest
  
  test :subject_class, :subject do
    assert_equality GraphSystem::GraphBox, subject_class
    assert_equality GraphSystem::GraphBox, subject.class
  end

end
