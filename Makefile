all: pdf

clean: clean-pdf

################################################################################

ROOT_PDF_URL = http://scopingcomments.eisgatewaypacificwa.gov/Verbal_Comments

BELLINGHAM_PDF_URL = ${ROOT_PDF_URL}/Bellingham_Verbal_Comments.pdf
FERNDALE_PDF_URL = ${ROOT_PDF_URL}/Ferndale_Verbal_Comments.pdf
FRIDAY_HARBOR_PDF_URL = ${ROOT_PDF_URL}/Friday_Harbor_Verbal_Comments.pdf
MOUNT_VERNON_PDF_URL = ${ROOT_PDF_URL}/Mount_Vernon_Verbal_Comments.pdf
SEATTLE_PDF_URL = ${ROOT_PDF_URL}/Seattle_Verbal_Comments.pdf
SPOKANE_PDF_URL = ${ROOT_PDF_URL}/Spokane_Verbal_Comments.pdf
VANCOUVER_PDF_URL = ${ROOT_PDF_URL}/Vancouver_Verbal_Comments.pdf

bellingham-pdf:
	mkdir -p pdfs
	wget ${BELLINGHAM_PDF_URL} -O pdfs/bellingham.pdf

ferndale-pdf:
	mkdir -p pdfs
	wget ${FERNDALE_PDF_URL} -O pdfs/ferndale.pdf

friday-harbor-pdf:
	mkdir -p pdfs
	wget ${FRIDAY_HARBOR_PDF_URL} -O pdfs/friday_harbor.pdf

mount-vernon-pdf:
	mkdir -p pdfs
	wget ${MOUNT_VERNON_PDF_URL} -O pdfs/mount_vernon.pdf

seattle-pdf:
	mkdir -p pdfs
	wget ${SEATTLE_PDF_URL} -O pdfs/seattle.pdf

spokane-pdf:
	mkdir -p pdfs
	wget ${SPOKANE_PDF_URL} -O pdfs/spokane.pdf

vancouver-pdf:
	mkdir -p pdfs
	wget ${VANCOUVER_PDF_URL} -O pdfs/vancouver.pdf

clean-pdf:
	rm -rf pdfs

pdf: bellingham-pdf ferndale-pdf friday-harbor-pdf mount-vernon-pdf seattle-pdf spokane-pdf vancouver-pdf
