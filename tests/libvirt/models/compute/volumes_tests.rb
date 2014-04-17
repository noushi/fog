Shindo.tests('Fog::Compute[:libvirt] | volumes collection', ['libvirt']) do

  volumes = Fog::Compute[:libvirt].volumes

  tests('The volumes collection') do
    test('should not be empty') { not volumes.empty? }
    test('should be a kind of Fog::Compute::Libvirt::Volumes') { volumes.kind_of? Fog::Compute::Libvirt::Volumes }
    tests('should be able to reload itself').succeeds { volumes.reload }
    tests('should be able to get a model') do
      tests('by instance uuid').succeeds { volumes.get volumes.first.id }
    end
    tests('should be able to delete a volume') do
      puts "#{volumes.size}"
      new_vol = volumes.first.clone_volume('new_vol')
      vol_name = "fog-shindo-libvirt-#{rand(10000)}.qcow2"
      puts vol_name
      volumes.create(:name => vol_name,
                     :allocation => "10M",
                     :capacity => '10M',
                     :format_type => 'qcow2',
                     :pool_name => 'default')
      initial_count = volumes.size
      volumes.destroy new_vol.id #should maybe catch some exception here
      volumes.reload
      test('by id') do
        puts "#{initial_count} == (#{volumes.size} + 1)"
        initial_count == (volumes.size + 1) 
      end
    end
  end

end
