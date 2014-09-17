#!/bin/bash

num_options=0

while getopts ":f:l:x:y:W:H:c:o:" opt; do
    
    case ${opt} in
	f)
	    first_page=${OPTARG}
	    ;;
	l)
	    last_page=${OPTARG}
	    ;;
	x)
	    crop_x=${OPTARG}
	    ;;
	y)
	    crop_y=${OPTARG}
	    ;;
	W)
	    crop_width=${OPTARG}
	    ;;
	H)
	    crop_height=${OPTARG}
	    ;;
	c)
	    city=${OPTARG}
	    pdf_path=pdfs/${OPTARG}.pdf
	    ;;
	o)
	    output_dir=${OPTARG}
	    ;;
	\?)
	    echo "invalid"
	    exit 1
	    ;;
	:)
	    echo "Option -${OPTARG} requires an argument."
	    exit 1
	    ;;
    esac
done

if [ ! -d ./tmp ]; then
    mkdir -p ./tmp
fi

batch_tmp_path=./tmp/${RANDOM}${RANDOM}

echo "" > ${batch_tmp_path}-output.txt

for page in `seq ${first_page} ${last_page}`;
do
    page_tmp_path=./tmp/${RANDOM}${RANDOM}
    
    pdftoppm \
	-f ${page} \
	-l ${page} \
	-x ${crop_x} \
	-y ${crop_y} \
	-W ${crop_width} \
	-H ${crop_height} \
	-singlefile \
	-jpeg \
	${pdf_path} \
	${page_tmp_path}
    
    page_num_fmt=`printf "%03d" ${page}`

    tesseract ${page_tmp_path}.jpg ${batch_tmp_path}-${page_num_fmt}

    cat ${batch_tmp_path}-output.txt ${batch_tmp_path}-${page_num_fmt}.txt \
	> ${batch_tmp_path}-tmp.txt
    if [ ! -d pages/${city}/${output_dir} ]; then
	mkdir -p pages/${city}
    fi
    mv ${batch_tmp_path}-${page_num_fmt}.txt \
	pages/${city}/${output_dir}/${page_num_fmt}.txt
    echo "pages/${city}/${output_dir}/${page_num_fmt}.txt"
    mv ${batch_tmp_path}-tmp.txt ${batch_tmp_path}-output.txt

    rm ${page_tmp_path}.jpg
done

mv ${batch_tmp_path}-output.txt pages/${city}/${output_dir}/cat.txt
echo "pages/${city}/${output_dir}/cat.txt"
