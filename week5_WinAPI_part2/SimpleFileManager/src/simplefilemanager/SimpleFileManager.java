package simplefilemanager;

import javax.swing.UIManager;

public class SimpleFileManager {
    public static void main(String[] args) {
        try {
            // Giao diện hệ điều hành
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Hiển thị cửa sổ giao diện
        java.awt.EventQueue.invokeLater(() -> {
            new MainForm().setVisible(true);
        });
    }
}
