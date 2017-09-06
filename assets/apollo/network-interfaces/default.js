import {createNetworkInterface} from "apollo-phoenix-websocket"

const host = process.browser ? location.origin.replace(/^http/, "ws") : "ws://127.0.0.1:4000"

export default () => createNetworkInterface({
  uri: `${host}/socket`
})
