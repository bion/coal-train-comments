all: pages populate-db

clean: clean-pdf clean-pages clean-db
	rm -f *.txt
	rm -f *.jpg
	rm -rf ./tmp
	rm -f *.pyc
	rm -rf __pycache__

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
	@${WGET} ${BELLINGHAM_PDF_URL} -O pdfs/bellingham.pdf
	@echo "Downloaded ${BELLINGHAM_PDF_URL}"

pdfs/ferndale.pdf: pdfs
	@${WGET} ${FERNDALE_PDF_URL} -O pdfs/ferndale.pdf
	@echo "Downloaded ${FERNDALE_PDF_URL}"

pdfs/friday_harbor.pdf: pdfs
	@${WGET} ${FRIDAY_HARBOR_PDF_URL} -O pdfs/friday_harbor.pdf
	@echo "Downloaded ${FRIDAY_HARBOR_PDF_URL}"

pdfs/mount_vernon.pdf: pdfs
	@${WGET} ${MOUNT_VERNON_PDF_URL} -O pdfs/mount_vernon.pdf
	@echo "Downloaded ${MOUNT_VERNON_PDF_URL}"

pdfs/seattle.pdf: pdfs
	@${WGET} ${SEATTLE_PDF_URL} -O pdfs/seattle.pdf
	@echo "Downloaded ${SEATTLE_PDF_URL}"

pdfs/spokane.pdf: pdfs
	@${WGET} ${SPOKANE_PDF_URL} -O pdfs/spokane.pdf
	@echo "Downloaded ${SPOKANE_PDF_URL}"

pdfs/vancouver.pdf: pdfs
	@${WGET} ${VANCOUVER_PDF_URL} -O pdfs/vancouver.pdf
	@echo "Downloaded ${VANCOUVER_PDF_URL}"

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

OCR_PDF = bash ocr-pdf.sh

pages/bellingham/ivc_tape_recorder: pdfs/bellingham.pdf
	@mkdir -p pages/bellingham/ivc_tape_recorder
	@${OCR_PDF} -f 5 -l 19 -x 90 -y 99 -W 1095 -H 1404 -c bellingham \
		-o ivc_tape_recorder

pages/bellingham/pvc_room1_index: pdfs/bellingham.pdf
	@mkdir -p pages/bellingham/pvc_room1_index
	@${OCR_PDF} -f 22 -l 26 -x 273 -y 264 -W 885 -H 1308 -c bellingham \
		-o pvc_room1_index

pages/bellingham/pvc_room1_comments: pdfs/bellingham.pdf
	@mkdir -p pages/bellingham/pvc_room1_comments
	@${OCR_PDF} -f 27 -l 143 -x 276 -y 261 -W 879 -H 1305 -c bellingham \
		-o pvc_room1_comments

pages/bellingham/pvc_room2_index: pdfs/bellingham.pdf
	@mkdir -p pages/bellingham/pvc_room2_index
	@${OCR_PDF} -f 146 -l 150 -x 264 -y 273 -W 888 -H 1281 -c bellingham \
		-o pvc_room2_index

pages/bellingham/pvc_room2_comments: pdfs/bellingham.pdf
	@mkdir -p pages/bellingham/pvc_room2_comments
	@${OCR_PDF} -f 151 -l 300 -x 267 -y 267 -W 888 -H 1287 -c bellingham \
		-o pvc_room2_comments

pages/bellingham: pages/bellingham/ivc_tape_recorder \
	pages/bellingham/pvc_room1_index pages/bellingham/pvc_room1_comments \
	pages/bellingham/pvc_room2_index pages/bellingham/pvc_room2_comments

pages/ferndale/ivc_tape_recorder: pdfs/ferndale.pdf
	@mkdir -p pages/ferndale/ivc_tape_recorder
	@${OCR_PDF} -f 5 -l 18 -x 114 -y 120 -W 1059 -H 1407 -c ferndale \
		-o ivc_tape_recorder

pages/ferndale/ivc_transcriptionist: pdfs/ferndale.pdf
	@mkdir -p pages/ferndale/ivc_transcriptionist
	@${OCR_PDF} -f 21 -l 68 -x 150 -y 108 -W 993 -H 1440 -c ferndale \
		-o ivc_transcriptionist

pages/ferndale/pvc_room1: pdfs/ferndale.pdf
	@mkdir -p pages/ferndale/pvc_room1
	@${OCR_PDF} -f 71 -l 219 -x 153 -y 105 -W 1014 -H 1440 -c ferndale \
		-o pvc_room1

pages/ferndale: pages/ferndale/ivc_tape_recorder \
	pages/ferndale/ivc_transcriptionist pages/ferndale/pvc_room1

pages/friday_harbor/ivc_transcriptionist: pdfs/friday_harbor.pdf
	@mkdir -p pages/friday_harbor/ivc_transcriptionist
	@${OCR_PDF} -f 5 -l 52 -x 150 -y 105 -W 969 -H 1440 -c friday_harbor \
		-o ivc_transcriptionist

pages/friday_harbor/pvc_room1: pdfs/friday_harbor.pdf
	@mkdir -p pages/friday_harbor/pvc_room1
	@${OCR_PDF} -f 56 -l 179 -x 162 -y 105 -W 984 -H 1440 -c friday_harbor \
		-o pvc_room1

pages/friday_harbor: pages/friday_harbor/ivc_transcriptionist \
	pages/friday_harbor/pvc_room1

pages/mount_vernon/ivc_tape_recorder: pdfs/mount_vernon.pdf
	@mkdir -p pages/mount_vernon/ivc_tape_recorder
	@${OCR_PDF} -f 4 -l 7 -x 138 -y 129 -W 1017 -H 1398 -c mount_vernon \
		-o ivc_tape_recorder

pages/mount_vernon/ivc_transcriptionist_index: pdfs/mount_vernon.pdf
	@mkdir -p pages/mount_vernon/ivc_transcriptionist_index
	@${OCR_PDF} -f 10 -l 11 -x 264 -y 264 -W 888 -H 1296 -c mount_vernon \
		-o ivc_transcriptionist_index

pages/mount-vernon/ivc_transcriptionist_comments: pdfs/mount_vernon.pdf
	@mkdir -p pages/mount-venron/ivc_transcriptionist_comments
	@${OCR_PDF} -f 12 -l 55 -x 279 -y 270 -W 879 -H 1290 -c mount_vernon \
		-o ivc_transcriptionist_comments

pages/mount_vernon/pvc_room1_index: pdfs/mount_vernon.pdf
	@mkdir -p pages/mount_vernon/pvc_room1_index
	@${OCR_PDF} -f 58 -l 59 -x 276 -y 273 -W 876 -H 1287 -c mount_vernon \
		-o pvc_room1_index

pages/mount_vernon/pvc_room1_comments: pdfs/mount_vernon.pdf
	@mkdir -p pages/mount_vernon/pvc_room1_comments
	@${OCR_PDF} -f 60 -l 173 -x 267 -y 270 -W 885 -H 1281 -c mount_vernon \
		-o pvc_room2_comments

pages/mount_vernon: pages/mount_vernon/ivc_tape_recorder \
	pages/mount_vernon/ivc_transcriptionist_index \
	pages/mount_vernon/pvc_room1_index \
	pages/mount_vernon/pvc_room2_comments

pages/seattle/ivc_tape_recorder: pdfs/seattle.pdf
	@mkdir -p pages/seattle/ivc_tape_recorder
	@${OCR_PDF} -f 4 -l 18 -x 105 -y 114 -W 1068 -H 1416 -c seattle \
		-o ivc_tape_recorder

pages/seattle/pvc_room1: pdfs/seattle.pdf
	@mkdir -p pages/seattle/pvc_room1
	@${OCR_PDF} -f 21 -l 129 -x 150 -y 105 -W 1023 -H 1437 -c seattle \
		-o pvc_room1

pages/seattle/pvc_room2: pdfs/seattle.pdf
	@mkdir -p pages/seattle/pvc_room2
	@${OCR_PDF} -f 135 -l 245 -x 153 -y 102 -W 1053 -H 1443 -c seattle \
		-o pvc_room2

pages/seattle: pages/seattle/ivc_tape_recorder pages/seattle/pvc_room1 \
	pages/seattle/pvc_room2

pages/spokane/ivc_transcriptionist: pdfs/spokane.pdf
	@mkdir -p pages/spokane/ivc_transcriptionist
	@${OCR_PDF} -f 6 -l 61 -x 149 -y 69 -W 1032 -H 1455 -c spokane \
		-o ivc_transcriptionist

pages/spokane/pvc_room1: pdfs/spokane.pdf
	@mkdir -p pages/spokane/pvc_room1
	@${OCR_PDF} -f 96 -l 194 -x 153 -y 75 -W 1023 -H 1443 -c spokane \
		-o pvc_room1

pages/spokane: pages/spokane/ivc_transcriptionist pages/spokane/pvc_room1

pages/vancouver/ivc_tape_recorder: pdfs/vancouver.pdf
	@mkdir -p pages/vancouver/ivc_tape_recorder
	@${OCR_PDF} -f 4 -l 12 -x 129 -y 126 -W 1038 -H 1404 -c vancouver \
		-o ivc_tape_recorder

pages/vancouver/pvc_room1: pdfs/vancouver.pdf
	@mkdir -p pages/vancouver/pvc_room1
	@${OCR_PDF} -f 16 -l 145 -x 264 -y 153 -W 936 -H 1338 -c vancouver \
		-o pvc_room1

pages/vancouver/pvc_room2: pdfs/vancouver.pdf
	@mkdir -p pages/vancouver/pvc_room2
	@${OCR_PDF} -f 150 -l 260 -x 261 -y 162 -W 930 -H 1335 -c vancouver \
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

################################################################################
## The following targets index the pages and generate a database containing the
## results. These targets invoke individual Python functions using
## call_db_function.sh. Every function resides in db.py.

coaltrain.db:
	@sh call_db_function.sh create_db

bellingham/pvc_room1-db: pages/bellingham/pvc_room1_index coaltrain.db
	@sh call_db_function.sh insert_bellingham_pvc_room1_index
	@echo "Inserted Bellingham PVC (Room 1) index into database."

bellingham/pvc_room2-db: pages/bellingham/pvc_room2_index coaltrain.db
	@sh call_db_function.sh insert_bellingham_pvc_room2_index
	@echo "Inserted Bellingham PVC (Room 2) index into database."

bellingham/ivc_tape_recorder-db: pages/bellingham/ivc_tape_recorder coaltrain.db
	@sh call_db_function.sh insert_bellingham_ivc_tape_recorder
	@echo "Inserted Bellingham IVC (recorder) index into database."

ferndale/ivc_tape_recorder-db: pages/ferndale/ivc_tape_recorder coaltrain.db
	@sh call_db_function.sh insert_ferndale_ivc_tape_recorder
	@echo "Inserted Ferndale IVC (recorder) index into database."

ferndale/ivc_transcriptionist-db: pages/ferndale/ivc_transcriptionist \
	coaltrain.db
	@sh call_db_function.sh insert_ferndale_ivc_transcriptionist
	@echo "Inserted Ferndale IVC (court reporter) index into database."

ferndale/pvc_room1-db: pages/ferndale/pvc_room1 coaltrain.db
	@sh call_db_function.sh insert_ferndale_pvc_room1
	@echo "Inserted Ferndale PVC (Room 1) index into database."

friday_harbor/ivc_transcriptionist-db: \
	pages/friday_harbor/ivc_transcriptionist coaltrain.db
	@sh call_db_function.sh insert_friday_harbor_ivc_transcriptionist
	@echo "Inserted Friday Harbor IVC (court reporter) index into database."

friday_harbor/pvc_room1-db: pages/friday_harbor/pvc_room1 coaltrain.db
	@sh call_db_function.sh insert_friday_harbor_pvc_room1
	@echo "Inserted Friday Harbor PVC (Room 1) index into database."

mount_vernon/ivc_transcriptionist-db: \
	pages/mount_vernon/ivc_transcriptionist_index \
	coaltrain.db
	@sh call_db_function.sh insert_mount_vernon_ivc_transcriptionist_index
	@echo "Inserted Mount Vernon IVC (court reporter) index into database."

mount_vernon/ivc_tape_recorder-db: pages/mount_vernon/ivc_tape_recorder \
	coaltrain.db
	@sh call_db_function.sh insert_mount_vernon_ivc_tape_recorder
	@echo "Inserted Mount Vernon IVC (recorder) index into database."

mount_vernon/pvc_room1-db: pages/mount_vernon/pvc_room1_index coaltrain.db
	@sh call_db_function.sh insert_mount_vernon_pvc_room1_index
	@echo "Inserted Mount Vernon PVC (Room 1) index into database."

seattle/ivc_tape_recorder-db: pages/seattle/ivc_tape_recorder coaltrain.db
	@sh call_db_function.sh insert_seattle_ivc_tape_recorder
	@echo "Inserted Seattle IVC (recorder) index into database."

seattle/pvc_room1-db: pages/seattle/pvc_room1 coaltrain.db
	@sh call_db_function.sh insert_seattle_pvc_room1
	@echo "Inserted Seattle PVC (Room 1) index into database."

seattle/pvc_room2-db: pages/seattle/pvc_room2 coaltrain.db
	@sh call_db_function.sh insert_seattle_pvc_room2
	@echo "Inserted Seattle PVC (Room 2) index into database."

spokane/ivc_transcriptionist-db: \
	pages/spokane/ivc_transcriptionist coaltrain.db
	@sh call_db_function.sh insert_spokane_ivc_transcriptionist
	@echo "Inserted Spokane IVC (court reporter) index into database."

spokane/pvc_room1-db: pages/spokane/pvc_room1 coaltrain.db
	@sh call_db_function.sh insert_spokane_pvc_room1
	@echo "Inserted Spokane PVC (Room 1) index into database."

vancouver/ivc_tape_recorder-db: pages/vancouver/ivc_tape_recorder coaltrain.db
	@sh call_db_function.sh insert_vancouver_ivc_tape_recorder
	@echo "Inserted Vancouver IVC (recorder) index into database."

vancouver/pvc_room1-db: pages/vancouver/pvc_room1 coaltrain.db
	@sh call_db_function.sh insert_vancouver_pvc_room1
	@echo "Inserted Vancouver PVC (Room 1) index into database."

vancouver/pvc_room2-db: pages/vancouver/pvc_room2 coaltrain.db
	@sh call_db_function.sh insert_vancouver_pvc_room2
	@echo "Inserted Vancouver PVC (Room 2) index into database."

insert-paths-db:
	@sh call_db_function.sh insert_paths
	@echo "Inserted paths into database."

populate-db: \
	bellingham/pvc_room1-db \
	bellingham/pvc_room2-db \
	bellingham/ivc_tape_recorder-db \
	ferndale/ivc_tape_recorder-db \
	ferndale/ivc_transcriptionist-db \
	ferndale/pvc_room1-db \
	friday_harbor/ivc_transcriptionist-db \
	friday_harbor/pvc_room1-db \
	mount_vernon/ivc_transcriptionist-db \
	mount_vernon/ivc_tape_recorder-db \
	mount_vernon/pvc_room1-db \
	seattle/ivc_tape_recorder-db \
	seattle/pvc_room1-db \
	seattle/pvc_room2-db \
	spokane/ivc_transcriptionist-db \
	spokane/pvc_room1-db \
	vancouver/ivc_tape_recorder-db \
	vancouver/pvc_room1-db \
	vancouver/pvc_room2-db \
	insert-paths-db
	@echo "Finished populating database."

clean-db:
	rm -f coaltrain.db
