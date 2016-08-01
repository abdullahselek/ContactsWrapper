platform :ios, '9.0'

def testing_pods
    pod 'OCMock', '~> 3.3'
    pod 'Quick'
    pod 'Expecta'
end

target 'ContactsWrapper' do
	 
  target 'ContactsWrapperTests' do
    use_frameworks!

    inherit! :search_paths
    testing_pods
  end

end
