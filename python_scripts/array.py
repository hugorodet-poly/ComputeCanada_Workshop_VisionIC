import sys
import yaml

if __name__ == '__main__':
    
    # Load config filename
    file = sys.argv[1]
    cfg = yaml.safe_load(open(file, 'r'))
    print("Loaded config file: ", file)

    # Print contents
    print("-> ", cfg['text'])
    if cfg['seed'] is not None:
        print("-> The seed parameter exists and is defined as : ", cfg['seed'])
    else:
        print("-> The seed parameter does not exist in this config file.")