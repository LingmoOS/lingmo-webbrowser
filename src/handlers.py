from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import *
from PySide6.QtWebEngineQuick import *
from PySide6.QtWebEngineCore import *
from PySide6.QtNetwork import *
import os
import re

mime2FileConvert={
    "text/h323": "H323 Text (*.323)",
    "video/3gpp": "3gpp Video (*.3gp)",
    "application/x-authoware-bin": "X-authoware-bin Application (*.aab)",
    "application/x-authoware-map": "X-authoware-map Application (*.aam)",
    "application/x-authoware-seg": "X-authoware-seg Application (*.aas)",
    "application/internet-property-stream": "Internet-property-stream Application (*.acx)",
    "application/postscript": "Postscript Application (*.ai *.eps *.ps)",
    "audio/x-aiff": "X-aiff Audio (*.aif *.aifc *.aiff)",
    "audio/X-Alpha5": "X-alpha5 Audio (*.als)",
    "application/x-mpeg": "X-mpeg Application (*.amc)",
    "application/octet-stream": "Octet-stream Application (*.ani *.avb *.bin  *.bpk *.class *.cur *.dmg *.dms *.exe *.lha *.lzh *.rar *.tad *.ttf)",
    "application/vnd.android.package-archive": "Vnd.android.package-archive Application (*.apk)",
    "text/plain": "Plain Text (*.asc *.bas *.c *.conf *.cpp *.h *.java *.log *.prop *.rc *.txt)",
    "application/astound": "Astound Application (*.asd *.asn)",
    "video/x-ms-asf": "X-ms-asf Video (*.asf *.asr *.asx)",
    "application/x-asap": "X-asap Application (*.asp)",
    "audio/basic": "Basic Audio (*.au *.snd)",
    "video/x-msvideo": "X-msvideo Video (*.avi)",
    "audio/amr-wb": "Amr-wb Audio (*.awb)",
    "application/olescript": "Olescript Application (*.axs)",
    "application/x-bcpio": "X-bcpio Application (*.bcpio)",
    "application/bld": "Bld Application (*.bld)",
    "application/bld2": "Bld2 Application (*.bld2)",
    "image/bmp": "Bmp Image (*.bmp)",
    "application/x-bzip2": "X-bzip2 Application (*.bz2)",
    "image/x-cals": "X-cals Image (*.cal *.mil)",
    "application/vnd.ms-pkiseccat": "Vnd.ms-pkiseccat Application (*.cat)",
    "application/x-cnc": "X-cnc Application (*.ccn)",
    "application/x-cocoa": "X-cocoa Application (*.cco)",
    "application/x-cdf": "X-cdf Application (*.cdf)",
    "application/x-x509-ca-cert": "X-x509-ca-cert Application (*.cer *.crt *.der)",
    "magnus-internal/cgi": "Cgi Magnus-internal (*.cgi)",
    "application/x-chat": "X-chat Application (*.chat)",
    "application/x-msclip": "X-msclip Application (*.clp)",
    "image/x-cmx": "X-cmx Image (*.cmx)",
    "application/x-cult3d-object": "X-cult3d-object Application (*.co)",
    "image/cis-cod": "Cis-cod Image (*.cod)",
    "application/x-cpio": "X-cpio Application (*.cpio)",
    "application/mac-compactpro": "Mac-compactpro Application (*.cpt)",
    "application/x-mscardfile": "X-mscardfile Application (*.crd)",
    "application/pkix-crl": "Pkix-crl Application (*.crl)",
    "application/x-csh": "X-csh Application (*.csh)",
    "chemical/x-csml": "X-csml Chemical (*.csm *.csml)",
    "text/css": "Css Text (*.css)",
    "x-lml/x-evm": "X-evm X-lml (*.dcm *.evm)",
    "application/x-director": "X-director Application (*.dcr *.dir *.dxr)",
    "image/x-dcx": "X-dcx Image (*.dcx)",
    "text/html": "Html Text (*.dhtml *.htm *.html *.hts *.stm)",
    "application/x-msdownload": "X-msdownload Application (*.dll)",
    "application/msword": "Msword Application (*.doc *.dot)",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document": "Vnd.openxmlformats-officedocument.wordprocessingml.document Application (*.docx)",
    "application/x-dvi": "X-dvi Application (*.dvi)",
    "drawing/x-dwf": "X-dwf Drawing (*.dwf)",
    "application/x-autocad": "X-autocad Application (*.dwg *.dxf)",
    "application/x-expandedbook": "X-expandedbook Application (*.ebk)",
    "chemical/x-embl-dl-nucleotide": "X-embl-dl-nucleotide Chemical (*.emb *.embl)",
    "application/epub+zip": "Epub+zip Application (*.epub)",
    "image/x-eri": "X-eri Image (*.eri)",
    "audio/echospeech": "Echospeech Audio (*.es *.esl)",
    "application/x-earthtime": "X-earthtime Application (*.etc)",
    "text/x-setext": "X-setext Text (*.etx)",
    "application/envoy": "Envoy Application (*.evy)",
    "image/x-freehand": "X-freehand Image (*.fh4 *.fh5 *.fhc)",
    "application/fractals": "Fractals Application (*.fif)",
    "x-world/x-vrml": "X-vrml X-world (*.flr *.vrml *.wrl *.wrz *.xaf *.xof)",
    "flv-application/octet-stream": "Octet-stream Flv-application (*.flv)",
    "application/x-maker": "X-maker Application (*.fm)",
    "image/x-fpx": "X-fpx Image (*.fpx)",
    "video/isivideo": "Isivideo Video (*.fvi)",
    "chemical/x-gaussian-input": "X-gaussian-input Chemical (*.gau)",
    "application/x-gca-compressed": "X-gca-compressed Application (*.gca)",
    "x-lml/x-gdb": "X-gdb X-lml (*.gdb)",
    "image/gif": "Gif Image (*.gif *.ifm)",
    "application/x-gps": "X-gps Application (*.gps)",
    "application/x-gtar": "X-gtar Application (*.gtar)",
    "application/x-gzip": "X-gzip Application (*.gz *.x-gzip)",
    "application/x-hdf": "X-hdf Application (*.hdf)",
    "text/x-hdml": "X-hdml Text (*.hdm *.hdml)",
    "application/winhlp": "Winhlp Application (*.hlp)",
    "application/mac-binhex40": "Mac-binhex40 Application (*.hqx)",
    "application/hta": "Hta Application (*.hta)",
    "text/x-component": "X-component Text (*.htc)",
    "text/webviewhtml": "Webviewhtml Text (*.htt)",
    "x-conference/x-cooltalk": "X-cooltalk X-conference (*.ice)",
    "image/x-icon": "X-icon Image (*.ico)",
    "image/ief": "Ief Image (*.ief)",
    "image/ifs": "Ifs Image (*.ifs)",
    "application/x-iphone": "X-iphone Application (*.iii)",
    "audio/melody": "Melody Audio (*.imy)",
    "application/x-internet-signup": "X-internet-signup Application (*.ins *.isp)",
    "application/x-ipscript": "X-ipscript Application (*.ips)",
    "application/x-ipix": "X-ipix Application (*.ipx)",
    "audio/x-mod": "X-mod Audio (*.it *.itz *.m15 *.mdz *.mod *.s3m *.s3z *.ult *.xm *.xmz)",
    "i-world/i-vrml": "I-vrml I-world (*.ivr)",
    "image/j2k": "J2k Image (*.j2k)",
    "text/vnd.sun.j2me.app-descriptor": "Vnd.sun.j2me.app-descriptor Text (*.jad)",
    "application/x-jam": "X-jam Application (*.jam)",
    "application/java-archive": "Java-archive Application (*.jar)",
    "image/pipeg": "Pipeg Image (*.jfif)",
    "application/x-java-jnlp-file": "X-java-jnlp-file Application (*.jnlp)",
    "image/jpg": "Jpg Image (*.jpg)",
    "image/jpeg": "Jpeg Image (*.jpe *.jpeg *.jpg *.jpz)",
    "application/x-javascript": "X-javascript Application (*.js)",
    "application/jwc": "Jwc Application (*.jwc)",
    "application/x-kjx": "X-kjx Application (*.kjx)",
    "x-lml/x-lak": "X-lak X-lml (*.lak)",
    "application/x-latex": "X-latex Application (*.latex)",
    "application/fastman": "Fastman Application (*.lcc)",
    "application/x-digitalloca": "X-digitalloca Application (*.lcl *.lcr)",
    "application/lgh": "Lgh Application (*.lgh)",
    "x-lml/x-lml": "X-lml X-lml (*.lml)",
    "x-lml/x-lmlpack": "X-lmlpack X-lml (*.lmlpack)",
    "video/x-la-asf": "X-la-asf Video (*.lsf *.lsx)",
    "application/x-msmediaview": "X-msmediaview Application (*.m13 *.m14 *.mvb)",
    "audio/x-mpegurl": "X-mpegurl Audio (*.m3u *.m3url)",
    "audio/mp4a-latm": "Mp4a-latm Audio (*.m4a *.m4b *.m4p)",
    "video/vnd.mpegurl": "Vnd.mpegurl Video (*.m4u)",
    "video/x-m4v": "X-m4v Video (*.m4v)",
    "audio/ma1": "Ma1 Audio (*.ma1)",
    "audio/ma2": "Ma2 Audio (*.ma2)",
    "audio/ma3": "Ma3 Audio (*.ma3)",
    "audio/ma5": "Ma5 Audio (*.ma5)",
    "application/x-troff-man": "X-troff-man Application (*.man)",
    "magnus-internal/imagemap": "Imagemap Magnus-internal (*.map)",
    "application/mbedlet": "Mbedlet Application (*.mbd)",
    "application/x-mascot": "X-mascot Application (*.mct)",
    "application/x-msaccess": "X-msaccess Application (*.mdb)",
    "application/x-troff-me": "X-troff-me Application (*.me)",
    "text/x-vmel": "X-vmel Text (*.mel)",
    "message/rfc822": "Rfc822 Message (*.mht *.mhtml *.nws)",
    "application/x-mif": "X-mif Application (*.mi *.mif)",
    "audio/mid": "Mid Audio (*.mid *.rmi)",
    "audio/midi": "Midi Audio (*.midi)",
    "audio/x-mio": "X-mio Audio (*.mio)",
    "application/x-skt-lbs": "X-skt-lbs Application (*.mmf)",
    "video/x-mng": "X-mng Video (*.mng)",
    "application/x-msmoney": "X-msmoney Application (*.mny)",
    "application/x-mocha": "X-mocha Application (*.moc *.mocha)",
    "application/x-yumekara": "X-yumekara Application (*.mof)",
    "chemical/x-mdl-molfile": "X-mdl-molfile Chemical (*.mol)",
    "chemical/x-mopac-input": "X-mopac-input Chemical (*.mop)",
    "video/quicktime": "Quicktime Video (*.mov *.qt)",
    "video/x-sgi-movie": "X-sgi-movie Video (*.movie)",
    "video/mpeg": "Mpeg Video (*.mp2 *.mpa *.mpe *.mpeg *.mpg *.mpv2)",
    "audio/mpeg": "Mpeg Audio (*.mp3 *.mpga)",
    "video/mp4": "Mp4 Video (*.mp4 *.mpg4)",
    "application/vnd.mpohun.certificate": "Vnd.mpohun.certificate Application (*.mpc)",
    "application/vnd.mophun.application": "Vnd.mophun.application Application (*.mpn)",
    "application/vnd.ms-project": "Vnd.ms-project Application (*.mpp)",
    "application/x-mapserver": "X-mapserver Application (*.mps)",
    "text/x-mrml": "X-mrml Text (*.mrl)",
    "application/x-mrm": "X-mrm Application (*.mrm)",
    "application/x-troff-ms": "X-troff-ms Application (*.ms)",
    "application/vnd.ms-outlook": "Vnd.ms-outlook Application (*.msg)",
    "application/metastream": "Metastream Application (*.mts *.mtx *.mtz *.mzv *.rtg)",
    "application/zip": "Zip Application (*.nar *.zip)",
    "image/nbmp": "Nbmp Image (*.nbmp)",
    "application/x-netcdf": "X-netcdf Application (*.nc)",
    "x-lml/x-ndb": "X-ndb X-lml (*.ndb)",
    "application/ndwn": "Ndwn Application (*.ndwn)",
    "application/x-nif": "X-nif Application (*.nif)",
    "application/x-scream": "X-scream Application (*.nmz)",
    "image/vnd.nok-oplogo-color": "Vnd.nok-oplogo-color Image (*.nokia-op-logo)",
    "application/x-netfpx": "X-netfpx Application (*.npx)",
    "audio/nsnd": "Nsnd Audio (*.nsnd)",
    "application/x-neva1": "X-neva1 Application (*.nva)",
    "application/oda": "Oda Application (*.oda)",
    "audio/ogg": "Ogg Audio (*.ogg)",
    "application/x-AtlasMate-Plugin": "X-atlasmate-plugin Application (*.oom)",
    "application/pkcs10": "Pkcs10 Application (*.p10)",
    "application/x-pkcs12": "X-pkcs12 Application (*.p12 *.pfx)",
    "application/x-pkcs7-certificates": "X-pkcs7-certificates Application (*.p7b *.spc)",
    "application/x-pkcs7-mime": "X-pkcs7-mime Application (*.p7c *.p7m)",
    "application/x-pkcs7-certreqresp": "X-pkcs7-certreqresp Application (*.p7r)",
    "application/x-pkcs7-signature": "X-pkcs7-signature Application (*.p7s)",
    "audio/x-pac": "X-pac Audio (*.pac)",
    "audio/x-epac": "X-epac Audio (*.pae)",
    "application/x-pan": "X-pan Application (*.pan)",
    "image/x-portable-bitmap": "X-portable-bitmap Image (*.pbm)",
    "image/x-pcx": "X-pcx Image (*.pcx)",
    "image/x-pda": "X-pda Image (*.pda)",
    "chemical/x-pdb": "X-pdb Chemical (*.pdb *.xyz)",
    "application/pdf": "Pdf Application (*.pdf)",
    "application/font-tdpfr": "Font-tdpfr Application (*.pfr)",
    "image/x-portable-graymap": "X-portable-graymap Image (*.pgm)",
    "image/x-pict": "X-pict Image (*.pict)",
    "application/ynd.ms-pkipko": "Ynd.ms-pkipko Application (*.pko)",
    "application/x-perl": "X-perl Application (*.pm)",
    "application/x-perfmon": "X-perfmon Application (*.pma *.pmc *.pml *.pmr *.pmw)",
    "application/x-pmd": "X-pmd Application (*.pmd)",
    "image/png": "Png Image (*.png *.pnz)",
    "image/x-portable-anymap": "X-portable-anymap Image (*.pnm)",
    "application/vnd.ms-powerpoint": "Vnd.ms-powerpoint Application (*.pot, *.pps *.ppt)",
    "image/x-portable-pixmap": "X-portable-pixmap Image (*.ppm)",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation": "Vnd.openxmlformats-officedocument.presentationml.presentation Application (*.pptx)",
    "application/x-cprplayer": "X-cprplayer Application (*.pqf)",
    "application/cprplayer": "Cprplayer Application (*.pqi)",
    "application/x-prc": "X-prc Application (*.prc)",
    "application/pics-rules": "Pics-rules Application (*.prf)",
    "application/x-ns-proxy-autoconfig": "X-ns-proxy-autoconfig Application (*.proxy)",
    "application/listenup": "Listenup Application (*.ptlk)",
    "application/x-mspublisher": "X-mspublisher Application (*.pub)",
    "video/x-pv-pvx": "X-pv-pvx Video (*.pvx)",
    "audio/vnd.qcelp": "Vnd.qcelp Audio (*.qcp)",
    "image/x-quicktime": "X-quicktime Image (*.qti *.qtif)",
    "text/vnd.rn-realtext3d": "Vnd.rn-realtext3d Text (*.r3t)",
    "audio/x-pn-realaudio": "X-pn-realaudio Audio (*.ra *.ram *.rm *.rmm *.rmvb)",
    "image/x-cmu-raster": "X-cmu-raster Image (*.ras)",
    "application/rdf+xml": "Rdf+xml Application (*.rdf)",
    "image/vnd.rn-realflash": "Vnd.rn-realflash Image (*.rf)",
    "image/x-rgb": "X-rgb Image (*.rgb)",
    "application/x-richlink": "X-richlink Application (*.rlf)",
    "audio/x-rmf": "X-rmf Audio (*.rmf)",
    "application/vnd.rn-realplayer": "Vnd.rn-realplayer Application (*.rnx)",
    "application/x-troff": "X-troff Application (*.roff *.t *.tr)",
    "image/vnd.rn-realpix": "Vnd.rn-realpix Image (*.rp)",
    "audio/x-pn-realaudio-plugin": "X-pn-realaudio-plugin Audio (*.rpm)",
    "text/vnd.rn-realtext": "Vnd.rn-realtext Text (*.rt)",
    "x-lml/x-gps": "X-gps X-lml (*.rte *.trk *.wpt)",
    "application/rtf": "Rtf Application (*.rtf)",
    "text/richtext": "Richtext Text (*.rtx)",
    "video/vnd.rn-realvideo": "Vnd.rn-realvideo Video (*.rv)",
    "application/x-rogerwilco": "X-rogerwilco Application (*.rwc)",
    "application/x-supercard": "X-supercard Application (*.sca)",
    "application/x-msschedule": "X-msschedule Application (*.scd)",
    "text/scriptlet": "Scriptlet Text (*.sct)",
    "application/e-score": "E-score Application (*.sdf)",
    "application/x-stuffit": "X-stuffit Application (*.sea *.sit)",
    "application/set-payment-initiation": "Set-payment-initiation Application (*.setpay)",
    "application/set-registration-initiation": "Set-registration-initiation Application (*.setreg)",
    "text/x-sgml": "X-sgml Text (*.sgm *.sgml)",
    "application/x-sh": "X-sh Application (*.sh)",
    "application/x-shar": "X-shar Application (*.shar)",
    "magnus-internal/parsed-html": "Parsed-html Magnus-internal (*.shtml)",
    "application/presentations": "Presentations Application (*.shw)",
    "image/si6": "Si6 Image (*.si6)",
    "image/vnd.stiwap.sis": "Vnd.stiwap.sis Image (*.si7)",
    "image/vnd.lgtwap.sis": "Vnd.lgtwap.sis Image (*.si9)",
    "application/vnd.symbian.install": "Vnd.symbian.install Application (*.sis)",
    "application/x-Koan": "X-koan Application (*.skd *.skm *.skp *.skt)",
    "application/x-salsa": "X-salsa Application (*.slc)",
    "audio/x-smd": "X-smd Audio (*.smd *.smz)",
    "application/smil": "Smil Application (*.smi *.smil)",
    "application/studiom": "Studiom Application (*.smp)",
    "application/futuresplash": "Futuresplash Application (*.spl)",
    "application/x-sprite": "X-sprite Application (*.spr *.sprite)",
    "application/sdp": "Sdp Application (*.sdp)",
    "application/x-spt": "X-spt Application (*.spt)",
    "application/x-wais-source": "X-wais-source Application (*.src)",
    "application/vnd.ms-pkicertstore": "Vnd.ms-pkicertstore Application (*.sst)",
    "application/hyperstudio": "Hyperstudio Application (*.stk)",
    "application/vnd.ms-pkistl": "Vnd.ms-pkistl Application (*.stl)",
    "image/svg+xml": "Svg+xml Image (*.svg *.svg)",
    "application/x-sv4cpio": "X-sv4cpio Application (*.sv4cpio)",
    "application/x-sv4crc": "X-sv4crc Application (*.sv4crc)",
    "image/vnd": "Vnd Image (*.svf)",
    "image/svh": "Svh Image (*.svh)",
    "x-world/x-svr": "X-svr X-world (*.svr)",
    "application/x-shockwave-flash": "X-shockwave-flash Application (*.swf *.swfl)",
    "text/x-speech": "X-speech Text (*.talk)",
    "application/x-tar": "X-tar Application (*.tar *.taz)",
    "application/x-timbuktu": "X-timbuktu Application (*.tbp *.tbt)",
    "application/x-tcl": "X-tcl Application (*.tcl)",
    "application/x-tex": "X-tex Application (*.tex)",
    "application/x-texinfo": "X-texinfo Application (*.texi *.texinfo)",
    "application/x-compressed": "X-compressed Application (*.tgz)",
    "application/vnd.eri.thm": "Vnd.eri.thm Application (*.thm)",
    "image/tiff": "Tiff Image (*.tif *.tiff)",
    "application/x-tkined": "X-tkined Application (*.tki *.tkined)",
    "application/toc": "Toc Application (*.toc)",
    "image/toy": "Toy Image (*.toy)",
    "application/x-msterminal": "X-msterminal Application (*.trm)",
    "audio/tsplayer": "Tsplayer Audio (*.tsi)",
    "application/dsptype": "Dsptype Application (*.tsp)",
    "text/tab-separated-values": "Tab-separated-values Text (*.tsv)",
    "application/t-time": "T-time Application (*.ttz)",
    "text/iuls": "Iuls Text (*.uls)",
    "application/x-ustar": "X-ustar Application (*.ustar)",
    "application/x-uuencode": "X-uuencode Application (*.uu *.uue)",
    "application/x-cdlink": "X-cdlink Application (*.vcd)",
    "text/x-vcard": "X-vcard Text (*.vcf)",
    "video/vdo": "Vdo Video (*.vdo)",
    "audio/vib": "Vib Audio (*.vib)",
    "video/vivo": "Vivo Video (*.viv *.vivo)",
    "application/vocaltec-media-desc": "Vocaltec-media-desc Application (*.vmd)",
    "application/vocaltec-media-file": "Vocaltec-media-file Application (*.vmf)",
    "application/x-dreamcast-vms-info": "X-dreamcast-vms-info Application (*.vmi)",
    "application/x-dreamcast-vms": "X-dreamcast-vms Application (*.vms)",
    "audio/voxware": "Voxware Audio (*.vox)",
    "audio/x-twinvq-plugin": "X-twinvq-plugin Audio (*.vqe)",
    "audio/x-twinvq": "X-twinvq Audio (*.vqf *.vql)",
    "x-world/x-vream": "X-vream X-world (*.vre *.vrw)",
    "x-world/x-vrt": "X-vrt X-world (*.vrt)",
    "workbook/formulaone": "Formulaone Workbook (*.vts)",
    "audio/x-wav": "X-wav Audio (*.wav)",
    "audio/x-ms-wax": "X-ms-wax Audio (*.wax)",
    "image/vnd.wap.wbmp": "Vnd.wap.wbmp Image (*.wbmp)",
    "application/vnd.ms-works": "Vnd.ms-works Application (*.wcm *.wdb *.wks *.wps)",
    "application/vnd.xara": "Vnd.xara Application (*.web *.xar)",
    "image/wavelet": "Wavelet Image (*.wi)",
    "image/webp": "Webp Image (*.webp)",
    "application/x-InstallShield": "X-installshield Application (*.wis)",
    "video/x-ms-wm": "X-ms-wm Video (*.wm)",
    "audio/x-ms-wma": "X-ms-wma Audio (*.wma)",
    "application/x-ms-wmd": "X-ms-wmd Application (*.wmd)",
    "application/x-msmetafile": "X-msmetafile Application (*.wmf)",
    "text/vnd.wap.wml": "Vnd.wap.wml Text (*.wml)",
    "application/vnd.wap.wmlc": "Vnd.wap.wmlc Application (*.wmlc)",
    "text/vnd.wap.wmlscript": "Vnd.wap.wmlscript Text (*.wmls *.wmlscript *.ws)",
    "application/vnd.wap.wmlscriptc": "Vnd.wap.wmlscriptc Application (*.wmlsc *.wsc)",
    "audio/x-ms-wmv": "X-ms-wmv Audio (*.wmv)",
    "video/x-ms-wmx": "X-ms-wmx Video (*.wmx)",
    "application/x-ms-wmz": "X-ms-wmz Application (*.wmz)",
    "image/x-up-wpng": "X-up-wpng Image (*.wpng)",
    "application/x-mswrite": "X-mswrite Application (*.wri)",
    "video/wavelet": "Wavelet Video (*.wv)",
    "video/x-ms-wvx": "X-ms-wvx Video (*.wvx)",
    "application/x-wxl": "X-wxl Application (*.wxl)",
    "image/x-xbitmap": "X-xbitmap Image (*.xbm)",
    "application/x-xdma": "X-xdma Application (*.xdm *.xdma)",
    "application/vnd.fujixerox.docuworks": "Vnd.fujixerox.docuworks Application (*.xdw)",
    "application/xhtml+xml": "Xhtml+xml Application (*.xht *.xhtm *.xhtml)",
    "application/vnd.ms-excel": "Vnd.ms-excel Application (*.xla *.xlc *.xlm *.xls *.xlt *.xlw)",
    "application/x-excel": "X-excel Application (*.xll)",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "Vnd.openxmlformats-officedocument.spreadsheetml.sheet Application (*.xlsx)",
    "application/xml": "Xml Application (*.xml)",
    "application/x-xpinstall": "X-xpinstall Application (*.xpi)",
    "image/x-xpixmap": "X-xpixmap Image (*.xpm)",
    "text/xml": "Xml Text (*.xsit *.xsl)",
    "text/xul": "Xul Text (*.xul)",
    "image/x-xwindowdump": "X-xwindowdump Image (*.xwd)",
    "application/x-yz1": "X-yz1 Application (*.yz1)",
    "application/x-compress": "X-compress Application (*.z)",
    "application/x-zaurus-zac": "X-zaurus-zac Application (*.zac)",
    "application/json": "Json Application (*.json)"
}

def is_valid_url(url):
    pattern = re.compile(
        r"^(?:http|ftp)s?://"
        r"(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|"
        r"localhost|"
        r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})"
        r"(?::\d+)?"
        r"(?:/?|[/?]\S+)$",
        re.IGNORECASE,
    )
    return re.match(pattern, url) is not None


def is_valid_localfile_url(url):
    pattern = re.compile(
        r'^((?:file):///)?(?:(?:[a-zA-Z]:|\.{1,2})?[\\/](?:[^\\?/*|<>:"]+[\\/])*)(?:(?:[^\\?/*|<>:"]+?)(?:\.[^.\\?/*|<>:"]+)?)?$'
    )
    return re.match(pattern, url) is not None


def is_valid_browser_url(url):
    pattern = re.compile(
        r'^((?:browser):/)?(?:(?:[a-zA-Z]:|\.{1,2})?[\\/](?:[^\\?/*|<>:"]+[\\/])*)(?:(?:[^\\?/*|<>:"]+?)(?:\.[^.\\?/*|<>:"]+)?)?$'
    )
    return re.match(pattern, url) is not None


class FileIconProvidingHandler(QQuickItem):
    def __init__(self):
        super().__init__()
        self.fileIconHandler = QAbstractFileIconProvider()

    @Slot(str, result=QUrl)
    def icon(self, path):
        fileInfo = QFileInfo(path)
        icon = self.fileIconHandler.icon(fileInfo)
        image = icon.pixmap(32, 32).toImage()
        buffer = QBuffer()
        buffer.open(QBuffer.OpenModeFlag.WriteOnly)
        image.save(buffer, "PNG")
        base64String = buffer.data().toBase64()
        url = QUrl("data:image/png;base64," + base64String)
        return url


class FileManagerHandler(QQuickItem):
    def __init__(self):
        super().__init__()

    @Slot(str)
    def open(self, path):
        QDesktopServices.openUrl(QUrl.fromLocalFile(path))

    @Slot(str)
    def delete(self, path):
        os.remove(path)


class EventFilter(QObject, QAbstractNativeEventFilter):
    ctrlWheelEvent = Signal()

    def __init__(self):
        super().__init__()

    def eventFilter(self, watched, event):
        if event.type() == QEvent.Type.Wheel:
            wheelEvent = QWheelEvent(event)
            if wheelEvent.modifiers() & Qt.KeyboardModifier.ControlModifier:
                self.ctrlWheelEvent.emit()
                return True
        return super().eventFilter(watched, event)


class UrlRedirectHandler(QQuickItem):
    def __init__(self):
        super().__init__()

    @Slot(str, result=str)
    def redirect(self, url):
        if is_valid_url(url):
            return url
        if is_valid_browser_url(url):
            return url
        elif is_valid_url("https://" + url):
            return "https://" + url
        elif is_valid_localfile_url(url):
            return url
        else:
            return "https://cn.bing.com/search?form=bing&q=" + url


class WebCookiesHandler(QQuickItem):
    def __init__(self):
        super().__init__()


class UrlSchemeHandler(QWebEngineUrlSchemeHandler):
    def __init__(self):
        super().__init__()

    def requestStarted(self, job: QWebEngineUrlRequestJob):
        job.fail(QWebEngineUrlRequestJob.Error.NoError)


class ClipboardHandler(QQuickItem):
    def __init__(self):
        super().__init__()
        self.clipboard=QClipboard()

    @Slot(str)
    def write(self,content):
        self.clipboard.setText(content)

class TypeNameConvertHandler(QQuickItem):
    def __init__(self):
        super().__init__()

    @Slot(list,result=list)
    def mime2File(self,l):
        newl=[]
        for i in l:
            newl.append(mime2FileConvert[i])
        return newl
