class DevSystem::BenchGenerator < DevSystem::SimpleGenerator
  
  # liza g bench name place=app +sorted

  def call_default
    @controller_class = Bench

    name!
    place!

    @args = Array command.simple_args[1..-1]
    ancestor = @controller_class

    # THIS IS A HACK! WILL BE FIXED SOON!
    if File.exist? "app/dev/benches/sorted_bench.rb"
      @sorted = command.simple_boolean_yes :sorted, "Use SortedBench?"
      log "@sorted = #{@sorted.inspect}"
      ancestor = "SortedBench" if @sorted
    end
    
    create_controller @name, @controller_class, @place, @path, ancestor: ancestor do |unit, test|
      unit.section :controller_section_1, caption: "liza bench #{ @name }"
      test.section :controller_test_section_1
    end
  end

  # liza g bench:examples

  def call_examples
    copy_examples Bench
  end

end

__END__

# view controller_section_1.rb.erb

  repetitions 1_000_000
  # repetitions 10_000_000
  # repetitions 100_000_000

  setup do
    log "repetitions: #{repetitions}"
  end

  #

<% if @args.any? -%>
<%   @args.each do |arg| -%>
  mark "<%= arg %>" do
    a = 1.to_s.to_sym
  end

<%   end -%>
<% else -%>
  mark "alternative 1" do
    a = "1".to_sym
  end

  mark "alternative 2" do
    a = :"1"
  end
<% end -%>
# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
