class DevSystem::BenchPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::BenchPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :call,
      :find,
      :forward,
      :parse
  end

  test :parse, true do
    env = {args: ["objects"]}
    subject.parse env
    assert_equality env[:bench_name_original], :objects
    assert_equality env[:bench_name], :objects
    assert_equality env[:bench_action_original], nil
    assert_equality env[:bench_action], nil
  end
  
  test :parse, true, :action do
    env = {args: ["objects:quadratic"]}
    subject.parse env
    assert_equality env[:args], ["objects:quadratic"]
    assert_equality env[:bench_name_original], :objects
    assert_equality env[:bench_name], :objects
    assert_equality env[:bench_action_original], :quadratic
    assert_equality env[:bench_action], :quadratic
  end
  
  test :parse, false do
    env = {args: ["x"]}
    subject.parse env
    assert_equality env[:args], ["x"]
    assert_equality env[:bench_name_original], :x
    assert_equality env[:bench_name], :x
    assert_equality env[:bench_action_original], nil
    assert_equality env[:bench_action], nil
  end
  
  test :parse, false, :action do
    env = {args: ["x:y"]}
    subject.parse env
    assert_equality env[:args], ["x:y"]
    assert_equality env[:bench_name_original], :x
    assert_equality env[:bench_name], :x
    assert_equality env[:bench_action_original], :y
    assert_equality env[:bench_action], :y
  end

  #

  test :find, true do
    env = {bench_name: :sorted}
    subject.find env
    assert_equality env[:bench_class], SortedBench
  end if defined? SortedBench
  
  test :find, false do
    env = {bench_name: :x}
    subject.find env
    assert false
  rescue DevSystem::BenchPanel::NotFoundError
    assert true  
  end

end
