import sys
import yaml

if __name__ == '__main__':
    
    # Load config filename
    file = sys.argv[1]
    cfg = yaml.safe_load(open(file, 'r'))
    print("Loaded config file: ", file)

    # Print contents
    print("-> ", cfg['text'])
