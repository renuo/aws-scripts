require 'json'

bucket = 'heleda-master'
image_base_path = 'app/public/spree/products'
image_ids = [1011, 1012, 864, 865, 866, 867, 868, 869, 707, 708, 709, 710, 711, 712, 773, 774, 775, 821, 822, 823, 779, 780, 781, 767, 768, 769, 812, 813, 814, 888, 889, 890, 873, 874, 875, 818, 819, 820, 815, 816, 817, 896, 897, 898, 770, 771, 772, 876, 877, 878, 879, 880, 881, 891, 892, 893, 1201, 1202, 1203, 885, 886, 887, 899, 900, 901, 1197, 870, 871, 872, 1199, 882, 883, 884, 1204, 1196, 1200, 1198, 1205, 1211, 1206, 1210, 1214, 1209, 1215, 1213, 1212, 1207, 1208, 1265, 1266, 1267, 1227, 1228, 1262, 1263, 1264]

prefixes = image_ids.map do |id|
  File.join(image_base_path, id.to_s)
end

versions = prefixes.map do |prefix|
  result = `aws s3api list-object-versions --bucket #{bucket} --prefix #{prefix} --query 'DeleteMarkers[].{Key: Key, VersionId: VersionId}'`
  JSON.parse(result) unless result.empty?
end

puts JSON.generate(versions.flatten)
