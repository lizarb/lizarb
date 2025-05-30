class DevSystem::LogoViewShell < DevSystem::ViewShell

  def self.get_svg
    new.get_svg
  end

  def get_svg
    @pallet = ["#005623", "#4fa63e", "#348b35"]
    render :logo, format: :svg
  end

end
