clear_screen :: (color := COLOR_CORN_LOWER_BLUE) {
    glClearColor(xx color.x, xx color.y, xx color.z, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}