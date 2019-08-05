import 'package:flutter/material.dart';
import '../../model/post.dart';
import '../../component/custom_linear_gradient.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage(this.post);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final double postAvatarSize = 150.0;
  double _sliderValue = 10.0;

  Widget get postImage {
    // Containers define the size of its children
    return Hero(
      tag: widget.post,
      child: Container(
        height: postAvatarSize,
        width: postAvatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(
                offset: const Offset(
                  1.0,
                  2.0,
                ),
                blurRadius: 2.0,
                spreadRadius: -1.0,
                color: const Color(0x33000000)),
            const BoxShadow(
                offset: const Offset(
                  1.0,
                  2.0,
                ),
                blurRadius: 3.0,
                spreadRadius: 0.0,
                color: const Color(0x24000000)),
            const BoxShadow(
                offset: const Offset(
                  3.0,
                  1.0,
                ),
                blurRadius: 4.0,
                spreadRadius: 2.0,
                color: const Color(0x1F000000)),
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.post.imageUrl),
          ),
        ),
      ),
    );
  }

  Widget get rating {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star,
          size: 40.0,
        ),
        Text(' ${widget.post.rating} / 10',
            style: Theme.of(context).textTheme.display2),
      ],
    );
  }

  Widget get postProfile {
    return CustomLinearGradient(
      myChild: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          postImage,
          Text(
            '${widget.post.title} 🎾',
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            child: Text(widget.post.description),
          ),
          rating
        ],
      ),
    );
  }

  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // In a row, column, listview, etc., a Flexible widget is a wrapper
              // that works much like CSS's flex-grow property.
              //
              // Any room left over in the main axis after
              // the widgets are given their width
              // will be distributed to all the flexible widgets
              // at a ratio based on the flex property you pass in.
              // Because this is the only Flexible widget,
              // it will take up all the extra space.
              //
              // In other words, it will expand as much as it can until
              // the all the space is taken up.
              Flexible(
                flex: 1,
                // A slider, like many form elements, needs to know its
                // own value and how to update that value.
                //
                // The slider will call onChanged whenever the value
                // changes. But it will only repaint when its value property
                // changes in the state using setState.
                //
                // The workflow is:
                // 1. User drags the slider.
                // 2. onChanged is called.
                // 3. The callback in onChanged sets the sliderValue state.
                // 4. Flutter repaints everything that relies on sliderValue,
                // in this case, just the slider at its new value.
                child: Slider(
                  activeColor: Colors.indigoAccent,
                  min: 0.0,
                  max: 15.0,
                  onChanged: (newRating) {
                    setState(() {
                      _sliderValue = newRating;
                    });
                  },
                  value: _sliderValue,
                ),
              ),
              // This is the part that displays the value of the slider.
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: Text(
                  '${_sliderValue.toInt()}',
                  style: Theme.of(context).textTheme.display1,
                ),
              )
            ],
          ),
        ),
        submitRatingButton,
      ],
    );
  }

  Widget get submitRatingButton {
    return RaisedButton(
      onPressed: updateRating,
      child: Text('Submit'),
      color: Colors.indigoAccent,
    );
  }

  void updateRating() {
    if (_sliderValue < 10) {
      _rattingErrorDialog();
    } else {
      setState(() {
        widget.post.rating = _sliderValue.toInt();
      });
    }
  }

  Future<Null> _rattingErrorDialog() async {
// showDialog is a built-in Flutter method
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error!'),
          content: Text("They're good posts, Brant. "),
          //This action uses the Navigator to dismiss the dialog.
          //This is where you could return information if you wanted to.
          actions: <Widget>[
            FlatButton(
              child: Text('Try Again'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Meet ${widget.post.title}'),
        ),
        body: ListView(
          children: <Widget>[
            postProfile,
            addYourRating,
          ],
        ));
  }
}
