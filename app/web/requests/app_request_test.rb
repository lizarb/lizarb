class AppRequestTest < Liza::RequestTest

  test :subject_class do
    assert subject_class == AppRequest
  end

end
