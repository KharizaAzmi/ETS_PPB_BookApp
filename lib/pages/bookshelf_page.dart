import 'package:bookshelf/model/book.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/db/database_helper.dart';
import 'package:bookshelf/widget/insert_book_widget.dart';

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({Key? key}) : super(key: key);

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  Future<List<Book>>? futureBooks;
  final bookDB = BookDB();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBooks();
  }

  void fetchBooks() {
    setState(() {
      futureBooks = bookDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: FutureBuilder<List<Book>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final books = snapshot.data!;

            return books.isEmpty ? const Center(
              child: Text('Empty book list', style: TextStyle(fontSize: 24)),
            ) : ListView.separated(
                itemBuilder: (context, index) {
                  final book = books[index];
                  final image = 'image';
                  return ListTile(
                    title: Text(
                      book.title,
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(image),
                    trailing: IconButton(
                      onPressed: () async {
                        await bookDB.delete(book.id);
                        fetchBooks();
                      },
                      icon: const Icon(Icons.delete, color: Colors.black,),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => InsertBookWidget(
                              onSubmit: (title) async {
                                await bookDB.update(id: book.id, title: title);
                                fetchBooks();
                                if (!mounted) return;
                                Navigator.of(context).pop();
                              }
                          ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 12,),
                itemCount: books.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => InsertBookWidget(
                  onSubmit: (title) async {
                    await bookDB.create(title: title);
                    if(!mounted) return;
                    fetchBooks();
                    Navigator.of(context).pop();
                  }
              )
          );
        },
      ),
    );
  }
}
