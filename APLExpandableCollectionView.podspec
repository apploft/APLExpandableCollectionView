Pod::Spec.new do |s|

  s.name         = "APLExpandableCollectionView"
  s.version      = "0.0.4"
  s.summary      = "UICollectionView subclass with vertically expandable and collapsible sections"

  s.description  = <<-DESC
                   * animated expand and collapse animation
                   * scrolls expanded section to visible
                   * customizable flow layout for iPhone and iPad
                   * supports single and multiple expanded sections
                   * supports addition of sections
                   DESC

  s.homepage     = "https://github.com/apploft/APLExpandableCollectionView"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author       = "Michael Kamphausen", "Stella Sadova"
  
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/apploft/APLExpandableCollectionView.git", :tag => s.version.to_s }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  
  s.requires_arc = true

end
