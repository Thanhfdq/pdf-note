import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfControllerPinch _pdfControllerPinch;

  @override
  void didChangeDependencies() {
    // Access Provider here instead of initState
    super.didChangeDependencies();
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    _pdfControllerPinch = PdfControllerPinch(
      // document: PdfDocument.openFile(
      //   tabsManager.tabs[tabsManager.currentTab].filePath,),
      document: PdfDocument.openAsset('assets/pdf/score.pdf'),
      initialPage: 1,
    );

    // Listen to page changes to update current page
    _pdfControllerPinch.pageListenable.addListener(() {
      setState(() {
        tabsManager.tabs[tabsManager.currentTab].pdfState
            ?.setCurrentPage(_pdfControllerPinch.page);
        tabsManager.tabs[tabsManager.currentTab].pdfState
            ?.setTotalPages(_pdfControllerPinch.pagesCount ?? 0);
      });
    });
  }

  @override
  void dispose() {
    _pdfControllerPinch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    int currentPage =
        tabsManager.tabs[tabsManager.currentTab].pdfState!.currentPage;
    int totalPage =
        tabsManager.tabs[tabsManager.currentTab].pdfState!.totalPages;
    return Column(
      children: [
        Expanded(
            child: PdfViewPinch(
          controller: _pdfControllerPinch,
        )),
        // Page Navigation Controls
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Go to Previous Page Button
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 1
                    ? () => _pdfControllerPinch.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        )
                    : null,
              ),
              // Display Current Page and Total Pages
              Text('$currentPage / $totalPage'),
              // Go to Next Page Button
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPage
                    ? () => _pdfControllerPinch.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        )
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
