import torch.nn as nn
import torch.nn.functional as F

class CIFARLeNet(nn.Module):
    def __init__(self):
        super(CIFARLeNet, self).__init__()
        self.conv1 = nn.Conv2d(in_channels=3, out_channels=64, kernel_size=5, stride=1, padding=2)
        self.pool = nn.MaxPool2d(kernel_size=2, stride=2, padding=0)
        self.conv2 = nn.Conv2d(in_channels=64, out_channels=64, kernel_size=5, stride=1, padding=2)
        self.fc1 = nn.Linear(64 * 8 * 8, 384)
        self.dropout1 = nn.Dropout(p=0.5)  # Dropout layer after the first fully connected layer
        self.fc2 = nn.Linear(384, 192)
        self.dropout2 = nn.Dropout(p=0.5)  # Dropout layer after the second fully connected layer
        self.fc3 = nn.Linear(192, 100)  # 100 output classes for CIFAR-100

    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))  # First conv + ReLU + MaxPool
        x = self.pool(F.relu(self.conv2(x)))  # Second conv + ReLU + MaxPool
        x = x.view(-1, 64 * 8 * 8)           # Flatten
        x = F.relu(self.fc1(x))              # First fully connected layer + ReLU
        x = self.dropout1(x)                 # Apply dropout after the first fully connected layer
        x = F.relu(self.fc2(x))              # Second fully connected layer + ReLU
        x = self.dropout2(x)                 # Apply dropout after the second fully connected layer
        x = self.fc3(x)                      # Output layer
        return x
    

__all__ = ["CIFARLeNet"]
