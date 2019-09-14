
bucket={bucket-name}@{region}
logSource=$1
contentType="application/x-compressed-tar"
s3Key={key}
s3Secret={password}

files=($(find $2 -not -name '*.gz' -not -name '*.zip' -not -name '*.tgz' -not -name '*.sh' -not -name '*.jar' -not -name '*.properties' -not -name '*.p12' -mtime +5))
for file in ${files[*]} ; do
	echo "Compressing file $file..."
	tar cfvz $file.tgz $file
	fileName=($(echo $file | rev | cut -d'/' -f 1 | rev))
	echo "Sending $fileName.tgz to S3..."
	./upload-to-s3.sh $s3Key $s3Secret $bucket $file.tgz $logSource/$fileName.tgz
	echo "Removing $fileName.tgz"
	rm -f $file
done

files=($(find $2 -name '*.gz' -o -name '*.zip' -o -name '*.tgz'))
echo $files
for file in ${files[*]} ; do
	fileName=($(echo $file | rev | cut -d'/' -f 1 | rev))
	echo "Sending $fileName to S3..."
	./upload-to-s3.sh $s3Key $s3Secret $bucket $file $logSource/$fileName
	rm -f $file
done
