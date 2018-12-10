message(“Configuring GUI components”)

set (RMGUILibrary_SRCS
	mainwindow.cpp
	logmessages.cpp
	)

set(RMGUILibrary_Resource
	mainwindow.ui
	icons.qrc
   )

set(RMGUILibrary_HDRS
	mainwindow.h
	)

add_library(RMGUILibrary ${RMGUILibrary_HDRS} ${RMGUILibrary_Resource} ${RMGUILibrary_SRCS})
target_link_libraries(RMGUILibrary Qt5::Widgets Qt5::Charts ${GPERFTOOLS_LIBRARIES} measurementControlLibrary)