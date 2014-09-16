all: pdf

clean: clean-pdf

################################################################################

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

pdfs/friday-harbor.pdf:
	${WGET} ${FRIDAY_HARBOR_PDF_URL} -O pdfs/friday_harbor.pdf

pdfs/mount-vernon.pdf:
	${WGET} ${MOUNT_VERNON_PDF_URL} -O pdfs/mount_vernon.pdf

pdfs/seattle.pdf:
	${WGET} ${SEATTLE_PDF_URL} -O pdfs/seattle.pdf

pdfs/spokane.pdf:
	${WGET} ${SPOKANE_PDF_URL} -O pdfs/spokane.pdf

pdfs/vancouver.pdf:
	${WGET} ${VANCOUVER_PDF_URL} -O pdfs/vancouver.pdf

clean-pdf:
	rm -rf pdfs

pdf: pdfs/bellingham.pdf pdfs/ferndale.pdf pdfs/friday-harbor.pdf pdfs/mount-vernon.pdf pdfs/seattle.pdf pdfs/spokane.pdf pdfs/vancouver.pdf
