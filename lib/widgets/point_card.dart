import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unbottled/widgets/widgets.dart';

class PointCard extends StatelessWidget {
  final String photoUrl;
  final double averageTaste;
  final VoidCallback onTap;

  const PointCard({Key key, this.photoUrl, this.onTap, this.averageTaste})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            photoUrl?.isNotEmpty == true
                ? Hero(
                    tag: 'point-photo',
                    child: Material(
                      color: Colors.white,
                      child: Ink(
                        // basically an Ink.image, but with borderRadius
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(photoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.photo,
                              size: 32,
                              color: Colors.black54,
                            ),
                            const Icon(
                              Icons.block,
                              size: 64,
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'No photo',
                          style: Theme.of(context).textTheme.title,
                        ),
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Hero(
                tag: 'point-taste',
                child: IconTheme(
                  data: IconThemeData(
                    color: photoUrl != null ? Colors.white : Colors.black,
                  ),
                  child: Rating(
                    rating: averageTaste ?? 0,
                    trailing: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
