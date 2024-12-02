import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/utils/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfViewerController;
  final TextEditingController _pageTextFieldController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late PdfTextSearchResult _searchResult;
  bool _showSearchBar = false;

  Future<void>? _initializePdf;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tabsManager = Provider.of<TabsManager>(context, listen: false);

    // Initialize the PDF controller and searchResult
    _initializePdf = Future(() {
      _pdfViewerController = PdfViewerController();
      _searchResult = PdfTextSearchResult();

      // Listen to page changes to update state in TabsManager
      final pdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
      _pdfViewerController.addListener(() {
        setState(() {
          pdfState?.setCurrentPage(_pdfViewerController.pageNumber);
          pdfState?.setTotalPages(_pdfViewerController.pageCount);
        });
      });
      _pageTextFieldController.text =
          pdfState == null ? "" : pdfState.currentPage.toString();
    });
  }

  void _search() {
    _searchResult = _pdfViewerController.searchText(_searchController.text);
    if (const bool.fromEnvironment('dart.library.js_util')) {
      setState(() {});
    } else {
      _searchResult.addListener(() {
        if (_searchResult.hasResult) {
          setState(() {});
        }
      });
    }
  }

  void _goToPage(String pageInput) {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    final pdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
    final page = int.tryParse(pageInput);
    if (page != null && page > 0 && page <= pdfState!.totalPages) {
      _pdfViewerController.jumpToPage(page);
    } else {
      NotificationHelper.showNotification(context, "Invalid page number");
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _pageTextFieldController.dispose();
    super.dispose();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Result'),
          content: const Text(
              'No more occurrences found. Would you like to continue to search from the beginning?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _searchResult.nextInstance();
                Navigator.of(context).pop();
              },
              child: const Text('YES'),
            ),
            TextButton(
              onPressed: () {
                _searchResult.clear();
                Navigator.of(context).pop();
              },
              child: const Text('NO'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    final currentTab = tabsManager.tabs[tabsManager.currentTab];
    final pdfState = currentTab.pdfState;

    return FutureBuilder<void>(
        future: _initializePdf,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error when loading pdf: ${snapshot.error}"));
          }

          // Once the PDF is loaded, display the viewer
          int currentPage = pdfState?.currentPage ?? 1;
          int totalPages = pdfState?.totalPages ?? 1;

          return Column(
            children: [
              // PDF View
              Expanded(
                child: SfPdfViewer.file(
                    File(tabsManager.tabs[tabsManager.currentTab].filePath),
                    controller: _pdfViewerController),
              ),
              // Search Bar (show if turn on showSearchBar)
              if (_showSearchBar)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: "Search",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          onPressed: () => _search()),
                      Visibility(
                        visible: _searchResult.hasResult,
                        child: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchResult.clear();
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: _searchResult.hasResult,
                        child: IconButton(
                          icon: const Icon(
                            Icons.navigate_before,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _searchResult.previousInstance();
                          },
                        ),
                      ),
                      Visibility(
                        visible: _searchResult.hasResult,
                        child: IconButton(
                          icon: const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if ((_searchResult.currentInstanceIndex ==
                                        _searchResult.totalInstanceCount &&
                                    const bool.fromEnvironment(
                                        'dart.library.js_util')) ||
                                (_searchResult.currentInstanceIndex ==
                                        _searchResult.totalInstanceCount &&
                                    _searchResult.isSearchCompleted)) {
                              _showDialog(context);
                            } else {
                              _searchResult.nextInstance();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              // Page Navigation Controls
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(CupertinoIcons.search),
                        onPressed: () => setState(() {
                              _showSearchBar = !_showSearchBar;
                            })),
                    Row(
                      // padding: const EdgeInsets.all(8.0),
                      children: [
                        // Previous Page Button
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: currentPage > 1
                              ? () => _pdfViewerController.previousPage()
                              : null,
                        ),
                        SizedBox(
                            width: 60,
                            child: TextField(
                              controller: _pageTextFieldController
                                ..text = currentPage.toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: _goToPage,
                            )),
                        // Display Current Page and Total Pages
                        Text(' / $totalPages'),
                        // Next Page Button
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: currentPage < totalPages
                              ? () => _pdfViewerController.nextPage()
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
