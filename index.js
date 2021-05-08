const express= require('express')
const app = express();
const http = require('http').createServer(app)
const multer = require('multer');
const mongoose = require('mongoose');


const imageSchema= mongoose.Schema(
    {
        image:{
            type: String,
            required: true
        }
    }
);


module.exports=mongoose.model("Images",imageSchema)

app.use('/uploads', express.static(__dirname +'/uploads'));

var storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'uploads')
    },
    filename: function (req, file, cb) {
      cb(null, new Date().toISOString()+file.originalname)
    }
  })


var upload = multer({ storage: storage })
  app.post('/upload', upload.single('myFile'), async(req, res, next) => {
    const file = req.file


      const imagepost= new model({
        image: file.path
      })
      const savedimage= await imagepost.save()
      res.json(savedimage)

  })

  app.get('/image',async(req, res)=>{
   const image = await model.find()
   res.json(image)

  })

mongoose.connect("mongodb+srv://YOUR_MONGODB_URL:<YOUR_MONGODB_URL>@cluster0.mohz6.mongodb.net/myFirstDatabase?retryWrites=true&w=majority",{ useNewUrlParser: true, useUnifiedTopology: true },()=>{
  console.log('db connnected')
})




app.get('/image',async(req, res)=>{
const image = await model.find()
res.json(image)
})




app.get('/', (req, res) => {
    res.send("Node Server is running. Yay!!")

})

//Socket Logic
const socketio = require('socket.io')(http)

socketio.on("connection", (userSocket) => {
    userSocket.on("send_message", (data) => {
        userSocket.broadcast.emit("receive_message", data)
    })
})

http.listen(process.env.PORT)
app.listen(process.env.PORT);

