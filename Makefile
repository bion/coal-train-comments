all: pages

clean: clean-pdf clean-pages
	rm -f *.txt
	rm -f *.jpg
	rm -rf ./tmp

################################################################################
## The following set of targets is concerned with downloading each of the PDFs
## containing verbal comments. To download all of the PDFs, make the 'pdf'
## target. The options to wget suppress its verbose output, so that it is easy
## to read the output of 'make -j `nproc` pdf'.

WGET_OPTS = -q
WGET = wget ${WGET_OPTS}

ROOT_PDF_URL = http://scopingcomments.eisgatewaypacificwa.gov/Verbal_Comments

BELLINGHAM_PDF_URL = ${ROOT_PDF_URL}/Bellingham_Verbal_Comments.pdf
FERNDALE_PDF_URL = ${ROOT_PDF_URL}/Ferndale_Verbal_Comments.pdf
FRIDAY_HARBOR_PDF_URL = ${ROOT_PDF_URL}/Friday_Harbor_Verbal_Comments.pdf
MOUNT_VERNON_PDF_URL = ${ROOT_PDF_URL}/Mount_Vernon_Verbal_Comments.pdf
SEATTLE_PDF_URL = ${ROOT_PDF_URL}/Seattle_Verbal_Comments.pdf
SPOKANE_PDF_URL = ${ROOT_PDF_URL}/Spokane_Verbal_Comments.pdf
VANCOUVER_PDF_URL = ${ROOT_PDF_URL}/Vancouver_Verbal_Comments.pdf

pdfs:
	mkdir -p pdfs

pdfs/bellingham.pdf: pdfs
	${WGET} ${BELLINGHAM_PDF_URL} -O pdfs/bellingham.pdf

pdfs/ferndale.pdf:
	${WGET} ${FERNDALE_PDF_URL} -O pdfs/ferndale.pdf

pdfs/friday_harbor.pdf:
	${WGET} ${FRIDAY_HARBOR_PDF_URL} -O pdfs/friday_harbor.pdf

pdfs/mount_vernon.pdf:
	${WGET} ${MOUNT_VERNON_PDF_URL} -O pdfs/mount_vernon.pdf

pdfs/seattle.pdf:
	${WGET} ${SEATTLE_PDF_URL} -O pdfs/seattle.pdf

pdfs/spokane.pdf:
	${WGET} ${SPOKANE_PDF_URL} -O pdfs/spokane.pdf

pdfs/vancouver.pdf:
	${WGET} ${VANCOUVER_PDF_URL} -O pdfs/vancouver.pdf

clean-pdf:
	rm -rf pdfs

pdf: pdfs/bellingham.pdf pdfs/ferndale.pdf pdfs/friday_harbor.pdf \
	pdfs/mount_vernon.pdf pdfs/seattle.pdf pdfs/spokane.pdf \
	pdfs/vancouver.pdf

################################################################################
## The targets below generate the pages for each different section in the verbal
## comments PDFs. This is done by extracting a cropped subsection of each page
## the section and running tesseract on it. The output is saved as a numbered
## text file in an appropriately named subdirectory.
##
## To generate all of the pages, make the 'pages' target. To only generate pages
## for a specific city, run, e.g., the 'pages/bellingham' target. To generate
## the pages for a specific section, run any of the 'pages/*/*' targets.
##
## Cleaning, likewise, is done by the various 'clean*' targets.

ocr_pdf = bash ocr-pdf.sh

pages/bellingham/ivc_tape_recorder: pdfs/bellingham.pdf
	mkdir -p pages/bellingham/ivc_tape_recorder
	${ocr_pdf} -f 5 -l 19 -x 90 -y 99 -W 1095 -H 1404 -c bellingham \
		-o ivc_tape_recorder

pages/bellingham/pvc_room1_index: pdfs/bellingham.pdf
	mkdir -p pages/bellingham/pvc_room1_index
	${ocr_pdf} -f 22 -l 26 -x 273 -y 264 -W 885 -H 1308 -c bellingham \
		-o pvc_room1_index

pages/bellingham/pvc_room1_comments: pdfs/bellingham.pdf
	mkdir -p pages/bellingham/pvc_room1_comments
	${ocr_pdf} -f 27 -l 143 -x 276 -y 261 -W 879 -H 1305 -c bellingham \
		-o pvc_room1_comments

pages/bellingham/pvc_room2_index: pdfs/bellingham.pdf
	mkdir -p pages/bellingham/pvc_room2_index
	${ocr_pdf} -f 146 -l 150 -x 264 -y 273 -W 888 -H 1281 -c bellingham \
		-o pvc_room2_index

pages/bellingham/pvc_room2_comments: pdfs/bellingham.pdf
	mkdir -p pages/bellingham/pvc_room2_comments
	${ocr_pdf} -f 151 -l 300 -x 267 -y 267 -W 888 -H 1287 -c bellingham \
		-o pvc_room2_comments

pages/bellingham: pages/bellingham/ivc_tape_recorder \
	pages/bellingham/pvc_room1_index pages/bellingham/pvc_room1_comments \
	pages/bellingham/pvc_room2_index pages/bellingham/pvc_room2_comments

pages/ferndale/ivc_tape_recorder: pdfs/ferndale.pdf
	mkdir -p pages/ferndale/ivc_tape_recorder
	${ocr_pdf} -f 5 -l 18 -x 114 -y 120 -W 1059 -H 1407 -c ferndale \
		-o ivc_tape_recorder

pages/ferndale/ivc_transcriptionist: pdfs/ferndale.pdf
	mkdir -p pages/ferndale/ivc_transcriptionist
	${ocr_pdf} -f 21 -l 68 -x 150 -y 108 -W 993 -H 1440 -c ferndale \
		-o ivc_transcriptionist

pages/ferndale/pvc_room1: pdfs/ferndale.pdf
	mkdir -p pages/ferndale/pvc_room1
	${ocr_pdf} -f 71 -l 219 -x 153 -y 105 -W 1014 -H 1440 -c ferndale \
		-o pvc_room1

pages/ferndale: pages/ferndale/ivc_tape_recorder \
	pages/ferndale/ivc_transcriptionist pages/ferndale/pvc_room1

pages/friday_harbor/ivc_transcriptionist: pdfs/friday_harbor.pdf
	mkdir -p pages/friday_harbor/ivc_transcriptionist
	${ocr_pdf} -f 5 -l 52 -x 150 -y 105 -W 969 -H 1440 -c friday_harbor \
		-o ivc_transcriptionist

pages/friday_harbor/pvc_room1: pdfs/friday_harbor.pdf
	mkdir -p pages/friday_harbor/pvc_room1
	${ocr_pdf} -f 56 -l 179 -x 162 -y 105 -W 984 -H 1440 -c friday_harbor \
		-o pvc_room1

pages/friday_harbor: pages/friday_harbor/ivc_transcriptionist \
	pages/friday_harbor/pvc_room1

pages/mount_vernon/ivc_tape_recorder: pdfs/mount_vernon.pdf
	mkdir -p pages/mount_vernon/ivc_tape_recorder
	${ocr_pdf} -f 4 -l 7 -x 138 -y 129 -W 1017 -H 1398 -c mount_vernon \
		-o ivc_tape_recorder

pages/mount_vernon/ivc_transcriptionist_index: pdfs/mount_vernon.pdf
	mkdir -p pages/mount_vernon/ivc_transcriptionist_index
	${ocr_pdf} -f 10 -l 11 -x 264 -y 264 -W 888 -H 1296 -c mount_vernon \
		-o ivc_transcriptionist_index

pages/mount-venron/ivc_transcriptionist_comments: pdfs/mount_vernon.pdf
	mkdir -p pages/mount-venron/ivc_transcriptionist_comments
	${ocr_pdf} -f 12 -l 55 -x 279 -y 270 -W 879 -H 1290 -c mount_vernon \
		-o ivc_transcriptionist_comments

pages/mount_vernon/pvc_room1_index: pdfs/mount_vernon.pdf
	mkdir -p pages/mount_vernon/pvc_room1_index
	${ocr_pdf} -f 58 -l 59 -x 276 -y 273 -W 876 -H 1287 -c mount_vernon \
		-o pvc_room1_index

pages/mount_vernon/pvc_room2_comments: pdfs/mount_vernon.pdf
	mkdir -p pages/mount_vernon/pvc_room2_comments
	${ocr_pdf} -f 60 -l 173 -x 267 -y 270 -W 885 -H 1281 -c mount_vernon \
		-o pvc_room2_comments

pages/mount_vernon: pages/mount_vernon/ivc_tape_recorder \
	pages/mount_vernon/ivc_transcriptionist_index \
	pages/mount_vernon/pvc_room1_index \
	pages/mount_vernon/pvc_room2_comments

pages/seattle/ivc_tape_recorder: pdfs/seattle.pdf
	mkdir -p pages/seattle/ivc_tape_recorder
	${ocr_pdf} -f 4 -l 18 -x 105 -y 114 -W 1068 -H 1416 -c seattle \
		-o ivc_tape_recorder

pages/seattle/pvc_room1: pdfs/seattle.pdf
	mkdir -p pages/seattle/pvc_room1
	${ocr_pdf} -f 21 -l 129 -x 150 -y 105 -W 1023 -H 1437 -c seattle \
		-o pvc_room1

pages/seattle/pvc_room2: pdfs/seattle.pdf
	mkdir -p pages/seattle/pvc_room2
	${ocr_pdf} -f 135 -l 245 -x 153 -y 102 -W 1053 -H 1443 -c seattle \
		-o pvc_room2

pages/seattle: pages/seattle/ivc_tape_recorder pages/seattle/pvc_room1 \
	pages/seattle/pvc_room2

pages/spokane/ivc_transcriptionist: pdfs/spokane.pdf
	mkdir -p pages/spokane/ivc_transcriptionist
	${ocr_pdf} -f 6 -l 61 -x 149 -y 69 -W 1032 -H 1455 -c spokane \
		-o ivc_transcriptionist

pages/spokane/pvc_room1: pdfs/spokane.pdf
	mkdir -p pages/spokane/pvc_room1
	${ocr_pdf} -f 96 -l 194 -x 153 -y 75 -W 1023 -H 1443 -c spokane \
		-o pvc_room1

pages/spokane: pages/spokane/ivc_transcriptionist pages/spokane/pvc_room1

pages/vancouver/ivc_tape_recorder: pdfs/vancouver.pdf
	mkdir -p pages/vancouver/ivc_tape_recorder
	${ocr_pdf} -f 4 -l 12 -x 129 -y 126 -W 1038 -H 1404 -c vancouver \
		-o ivc_tape_recorder

pages/vancouver/pvc_room1: pdfs/vancouver.pdf
	mkdir -p pages/vancouver/pvc_room1
	${ocr_pdf} -f 16 -l 145 -x 264 -y 153 -W 936 -H 1338 -c vancouver \
		-o pvc_room1

pages/vancouver/pvc_room2: pdfs/vancouver.pdf
	mkdir -p pages/vancouver/pvc_room2
	${ocr_pdf} -f 150 -l 260 -x 261 -y 162 -W 930 -H 1335 -c vancouver \
		-o pvc_room2

pages/vancouver: pages/vancouver/ivc_tape_recorder pages/vancouver/pvc_room1 \
	pages/vancouver/pvc_room2

pages: pages/bellingham pages/ferndale pages/friday_harbor \
	pages/mount_vernon pages/seattle pages/spokane pages/vancouver

clean-bellingham:
	rm -rf pages/bellingham

clean-ferndale:
	rm -rf pages/ferndale

clean-friday-harbor:
	rm -rf pages/friday_harbor

clean-mount-vernon:
	rm -rf pages/mount_vernon

clean-seattle:
	rm -rf pages/seattle

clean-spokane:
	rm -rf pages/spokane

clean-vancouver:
	rm -rf pages/vancouver

clean-pages: clean-bellingham clean-ferndale clean-friday-harbor \
	clean-mount-vernon clean-seattle clean-spokane clean-vancouver
	rm -rf pages
