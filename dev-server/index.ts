import { Hytopia } from "hytopia";

const game = new Hytopia({
  port: parseInt(process.env.HYTOPIA_PORT || "8080"),
  development: true,
});

game.init().then(() => {
  console.log("Hytopia dev server running on port", game.config.port);
}); 