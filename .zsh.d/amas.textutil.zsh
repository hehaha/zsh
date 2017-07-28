MY_MESSAGE_COLOR_E=$FG[b-red]
MY_MESSAGE_COLOR_W=$FG[b-yellow]
MY_MESSAGE_COLOR_I=$FG[b-green]

msgE() {
    printf "$MY_MESSAGE_COLOR_E E: $FG[white]%s \n" $1
}

msgW() {
    printf "$MY_MESSAGE_COLOR_W W: $FG[white]%s \n" $1
}

msgI() {
    printf "$MY_MESSAGE_COLOR_I I: $FG[white]%s \n" $1
}


