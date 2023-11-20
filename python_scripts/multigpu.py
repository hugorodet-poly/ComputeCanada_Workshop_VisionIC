
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from torch.utils.data import DataLoader
from torchvision import datasets
import torchvision.transforms as T

# Define your neural network model
class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.conv1 = nn.Conv2d(1, 32, 3, 1)
        self.conv2 = nn.Conv2d(32, 64, 3, 1)
        self.dropout1 = nn.Dropout(0.25)
        self.dropout2 = nn.Dropout(0.5)
        self.fc1 = nn.Linear(9216, 128)
        self.fc2 = nn.Linear(128, 10)

    def forward(self, x):
        x = self.conv1(x)
        x = F.relu(x)
        x = self.conv2(x)
        x = F.relu(x)
        x = F.max_pool2d(x, 2)
        x = self.dropout1(x)
        x = torch.flatten(x, 1)
        x = self.fc1(x)
        x = F.relu(x)
        x = self.dropout2(x)
        x = self.fc2(x)
        output = F.log_softmax(x, dim=1)
        return output


# Create an instance of the model
model = nn.DataParallel(Net())

# Define the loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.SGD(model.parameters(), lr=0.01)

# Check if GPUs are available
if torch.cuda.is_available():
    device = torch.device("cuda")
    model = model.to(device)
    print("Training on", torch.cuda.device_count(), "GPU(s)")
    for i in range(torch.cuda.device_count()):
        print('|\t', torch.cuda.get_device_name(i))


else:
    device = torch.device("cpu")
    print("Training on CPU")

# Load your dataset
train_dataset = datasets.MNIST(root='./data', train=True, download=True, transform=T.ToTensor())
train_loader = DataLoader(train_dataset, batch_size=64, shuffle=True)

# Training loop
for epoch in range(10):
    print('Epoch:', epoch+1)
    for i in range(torch.cuda.device_count()):
        print(f'Device {i} = {torch.cuda.get_device_name(i)} is :')
        print(f'\t- allocating {torch.cuda.memory_allocated(i)//1024//1024} MB')
        print(f'\t- reserving {torch.cuda.memory_reserved(i)//1024//1024} MB')
        print(f'\t- over {torch.cuda.get_device_properties(i).total_memory//1024//1024} MB')
        
        print(torch.cuda.memory_summary(abbreviated=True, device=torch.cuda.device(i)))
    running_loss = 0.0
    for i, data in enumerate(train_loader):
        inputs, labels = data[0].to(device), data[1].to(device)

        optimizer.zero_grad()

        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        running_loss += loss.item()
        if i % 100 == 99:
            print(f"[Epoch {epoch+1}, Batch {i+1}] Loss: {running_loss/100:.3f}")
            running_loss = 0.0

print("Training complete")
